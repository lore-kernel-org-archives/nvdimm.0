Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 6/6] nd_blk: add support for NVDIMM flags
Date: Thu, 28 May 2015 16:35:53 -0600
Message-Id: <1432852553-24865-7-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-api@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add support in the ND_BLK I/O path for the "latch" and "flush" flags
defined in the "Get Block NVDIMM Flags" _DSM function:

http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
Cc: linux-api@vger.kernel.org
---
 drivers/acpi/nfit.c        | 26 ++++++++++++++++++++++++--
 drivers/acpi/nfit.h        |  1 +
 include/uapi/linux/ndctl.h |  5 +++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 6cca50d1c690..0da84e067643 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -951,7 +951,9 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 	/* mmio->base must be mapped uncacheable */
 	writeq(cmd, mmio->base + offset);
 	nfit_blk->psync(nfit_blk);
-	/* FIXME: conditionally perform read-back if mandated by firmware */
+
+	if (nfit_blk->dimm_flags & ND_BLK_DCR_LATCH)
+		readq(mmio->base + offset);
 }
 
 static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk, void *iobuf,
@@ -983,8 +985,12 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk, void *iobuf,
 
 		if (write)
 			persistent_copy(mmio->aperture + offset, iobuf + copied, c);
-		else
+		else {
+			if (nfit_blk->dimm_flags & ND_BLK_FLUSH_REQUIRED)
+				persistent_flush(mmio->aperture + offset, c);
+
 			memcpy(iobuf + copied, mmio->aperture + offset, c);
+		}
 
 		copied += c;
 		len -= c;
@@ -1146,6 +1152,20 @@ static int nfit_blk_init_interleave(struct nfit_blk_mmio *mmio,
 	return 0;
 }
 
+static void nd_acpi_blk_get_flags(struct nd_bus_descriptor *nd_desc,
+		struct nd_dimm *nd_dimm, struct nfit_blk *nfit_blk)
+{
+	struct nd_cmd_dimm_flags flags;
+	int rc;
+
+	memset(&flags, 0, sizeof(flags));
+	rc = nd_desc->ndctl(nd_desc, nd_dimm, ND_CMD_DIMM_FLAGS, &flags,
+			sizeof(flags));
+
+	if (rc >= 0 && !flags.status)
+		nfit_blk->dimm_flags = flags.flags;
+}
+
 static int acpi_nfit_blk_region_enable(struct nd_bus *nd_bus, struct device *dev)
 {
 	struct nd_bus_descriptor *nd_desc = to_nd_desc(nd_bus);
@@ -1217,6 +1237,8 @@ static int acpi_nfit_blk_region_enable(struct nd_bus *nd_bus, struct device *dev
 		return rc;
 	}
 
+	nd_acpi_blk_get_flags(nd_desc, nd_dimm, nfit_blk);
+
 	nfit_flush = nfit_mem->nfit_flush;
 	if (nfit_flush && nfit_flush->flush->hint_count != 0) {
 		struct acpi_nfit_flush_address *flush = nfit_flush->flush;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 858719017bef..d22b04ac3d2c 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -139,6 +139,7 @@ struct nfit_blk {
 	u64 bdw_offset; /* post interleave offset */
 	u64 stat_offset;
 	u64 cmd_offset;
+	u32 dimm_flags;
 	void __iomem *flush_hint;
 	void (*psync)(struct nfit_blk *nfit_blk);
 };
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index e595751c613d..bb0fa1c611e0 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -30,6 +30,11 @@ struct nd_cmd_dimm_flags {
 	__u32 flags;
 } __packed;
 
+enum {
+	ND_BLK_FLUSH_REQUIRED = 1,
+	ND_BLK_DCR_LATCH = 2,
+};
+
 struct nd_cmd_get_config_size {
 	__u32 status;
 	__u32 config_size;
-- 
1.9.3

