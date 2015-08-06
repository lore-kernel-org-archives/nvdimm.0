Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/6] nd_blk: add support for "read flush" DSM flag
Date: Thu,  6 Aug 2015 11:43:19 -0600
Message-Id: <1438883000-9011-6-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for the "read flush" _DSM flag, as outlined in the DSM spec:

http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

This flag tells the ND BLK driver that it needs to flush the cache lines
associated with the aperture after the aperture is moved but before any new
data is read.  This ensures that any stale cache lines from the previous
contents of the aperture will be discarded from the processor cache, and the
new data will be read properly from the DIMM.  We know that the cache lines
are clean and will be discarded without any writeback because either a) the
previous aperture operation was a read, and we never modified the contents of
the aperture, or b) the previous aperture operation was a write and we must
have written back the dirtied contents of the aperture to the DIMM
before the I/O was completed.

By supporting the "read flush" flag we can also change the ND BLK aperture
mapping from write-combining to write-back via memremap_pmem().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/acpi/nfit.c | 18 +++++++++---------
 drivers/acpi/nfit.h |  6 +++++-
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 7c2638f..5bd6819 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1080,9 +1080,13 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 		if (rw)
 			memcpy_to_pmem(mmio->aperture + offset,
 					iobuf + copied, c);
-		else
+		else {
+			if (nfit_blk->dimm_flags & ND_BLK_READ_FLUSH)
+				flush_cache_pmem(mmio->aperture + offset, c);
+
 			memcpy_from_pmem(iobuf + copied,
 					mmio->aperture + offset, c);
+		}
 
 		copied += c;
 		len -= c;
@@ -1191,13 +1195,9 @@ static void __iomem *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
 	if (!res)
 		goto err_mem;
 
-	if (type == SPA_MAP_APERTURE) {
-		/*
-		 * TODO: memremap_pmem() support, but that requires cache
-		 * flushing when the aperture is moved.
-		 */
-		spa_map->iomem = ioremap_wc(start, n);
-	} else
+	if (type == SPA_MAP_APERTURE)
+		spa_map->aperture = memremap_pmem(start, n);
+	else
 		spa_map->iomem = ioremap_nocache(start, n);
 
 	if (!spa_map->iomem)
@@ -1267,7 +1267,7 @@ static int acpi_nfit_blk_get_flags(struct nvdimm_bus_descriptor *nd_desc,
 		nfit_blk->dimm_flags = flags.flags;
 	else if (rc == -ENOTTY) {
 		/* fall back to a conservative default */
-		nfit_blk->dimm_flags = ND_BLK_DCR_LATCH;
+		nfit_blk->dimm_flags = ND_BLK_DCR_LATCH | ND_BLK_READ_FLUSH;
 		rc = 0;
 	} else
 		rc = -ENXIO;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index f2c2bb7..7c6990e 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -41,6 +41,7 @@ enum nfit_uuids {
 };
 
 enum {
+	ND_BLK_READ_FLUSH = 1,
 	ND_BLK_DCR_LATCH = 2,
 };
 
@@ -149,7 +150,10 @@ struct nfit_spa_mapping {
 	struct acpi_nfit_system_address *spa;
 	struct list_head list;
 	struct kref kref;
-	void __iomem *iomem;
+	union {
+		void __iomem *iomem;
+		void __pmem  *aperture;
+	};
 };
 
 static inline struct nfit_spa_mapping *to_spa_map(struct kref *kref)
-- 
2.1.0

