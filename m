Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 6/6] nfit: add support for NVDIMM "latch" flag
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Jul 2015 10:41:09 -0400
Message-ID: <20150711144109.25013.53374.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, ross.zwisler@linux.intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

Add support in the NFIT BLK I/O path for the "latch" flag
defined in the "Get Block NVDIMM Flags" _DSM function:

http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

This flag requires the driver to read back the command register after it
is written in the block I/O path.  This ensures that the hardware has
fully processed the new command and moved the aperture appropriately.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |   33 ++++++++++++++++++++++++++++++++-
 drivers/acpi/nfit.h |    5 +++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 11aa513f2fda..628a42c41ab1 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1059,7 +1059,9 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 
 	writeq(cmd, mmio->base + offset);
 	wmb_blk(nfit_blk);
-	/* FIXME: conditionally perform read-back if mandated by firmware */
+
+	if (nfit_blk->dimm_flags & ND_BLK_DCR_LATCH)
+		readq(mmio->base + offset);
 }
 
 static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
@@ -1266,6 +1268,28 @@ static int nfit_blk_init_interleave(struct nfit_blk_mmio *mmio,
 	return 0;
 }
 
+static int acpi_nfit_blk_get_flags(struct nvdimm_bus_descriptor *nd_desc,
+		struct nvdimm *nvdimm, struct nfit_blk *nfit_blk)
+{
+	struct nd_cmd_dimm_flags flags;
+	int rc;
+
+	memset(&flags, 0, sizeof(flags));
+	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_DIMM_FLAGS, &flags,
+			sizeof(flags));
+
+	if (rc >= 0 && flags.status == 0)
+		nfit_blk->dimm_flags = flags.flags;
+	else if (rc == -ENOTTY) {
+		/* fall back to a conservative default */
+		nfit_blk->dimm_flags = ND_BLK_DCR_LATCH;
+		rc = 0;
+	} else
+		rc = -ENXIO;
+
+	return rc;
+}
+
 static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 		struct device *dev)
 {
@@ -1340,6 +1364,13 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 		return rc;
 	}
 
+	rc = acpi_nfit_blk_get_flags(nd_desc, nvdimm, nfit_blk);
+	if (rc < 0) {
+		dev_dbg(dev, "%s: %s failed get DIMM flags\n",
+				__func__, nvdimm_name(nvdimm));
+		return rc;
+	}
+
 	nfit_flush = nfit_mem->nfit_flush;
 	if (nfit_flush && nfit_flush->flush->hint_count != 0) {
 		nfit_blk->nvdimm_flush = devm_ioremap_nocache(dev,
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 815cb561cdba..79b6d83875c1 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -40,6 +40,10 @@ enum nfit_uuids {
 	NFIT_UUID_MAX,
 };
 
+enum {
+	ND_BLK_DCR_LATCH = 2,
+};
+
 struct nfit_spa {
 	struct acpi_nfit_system_address *spa;
 	struct list_head list;
@@ -131,6 +135,7 @@ struct nfit_blk {
 	u64 stat_offset;
 	u64 cmd_offset;
 	void __iomem *nvdimm_flush;
+	u32 dimm_flags;
 };
 
 enum spa_map_type {

