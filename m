Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 534FA21A02937
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 16:48:35 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2] libnvdimm, pfn: during init,
 clear errors in the metadata area
Date: Tue, 18 Sep 2018 17:48:31 -0600
Message-Id: <20180918234831.29197-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

If there are badblocks present in the 'struct page' area for pfn
namespaces, until now, the only way to clear them has been to force the
namespace into raw mode, clear the errors, and re-enable the fsdax mode.
This is clunky, given that it should be easy enough for the pfn driver
to do the same.

Add a new helper that uses the most recently available badblocks list to
check whether there are any badblocks that lie in the volatile struct
page area. If so, before initializing the struct pages, send down
targeted writes via nvdimm_write_bytes to write zeroes to the affected
blocks, and thus clear errors.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/pfn_devs.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

v2:
- Rename to nd_pfn_clear_memmap_errors() (Dan)
- Move the mode check into the clearing function (Dan)
- Use page aligned chunks to clear errors (Dan)
- make bb_present an int (Dan)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 3f7ad5bc443e..24c64090169e 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -361,6 +361,65 @@ struct device *nd_pfn_create(struct nd_region *nd_region)
 	return dev;
 }
 
+/*
+ * nd_pfn_clear_memmap_errors() clears any errors in the volatile memmap
+ * space associated with the namespace. If the memmap is set to DRAM, then
+ * this is a no-op. Since the memmap area is freshly initialized during
+ * probe, we have an opportunity to clear any badblocks in this area.
+ */
+static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
+{
+	struct nd_region *nd_region = to_nd_region(nd_pfn->dev.parent);
+	struct nd_namespace_common *ndns = nd_pfn->ndns;
+	void *zero_page = page_address(ZERO_PAGE(0));
+	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
+	int num_bad, meta_num, rc, bb_present;
+	sector_t first_bad, meta_start;
+	struct nd_namespace_io *nsio;
+
+	if (nd_pfn->mode != PFN_MODE_PMEM)
+		return 0;
+
+	nsio = to_nd_namespace_io(&ndns->dev);
+	meta_start = (SZ_4K + sizeof(*pfn_sb)) >> 9;
+	meta_num = (le64_to_cpu(pfn_sb->dataoff) >> 9) - meta_start;
+
+	do {
+		unsigned long zero_len;
+		u64 nsoff;
+
+		bb_present = badblocks_check(&nd_region->bb, meta_start,
+				meta_num, &first_bad, &num_bad);
+		if (bb_present) {
+			dev_dbg(&nd_pfn->dev, "meta: %x badblocks at %lx\n",
+					num_bad, first_bad);
+			nsoff = ALIGN_DOWN((nd_region->ndr_start
+					+ (first_bad << 9)) - nsio->res.start,
+					PAGE_SIZE);
+			zero_len = ALIGN(num_bad << 9, PAGE_SIZE);
+			while (zero_len) {
+				unsigned long chunk = min(zero_len, PAGE_SIZE);
+
+				rc = nvdimm_write_bytes(ndns, nsoff, zero_page,
+							chunk, 0);
+				if (rc)
+					break;
+
+				zero_len -= chunk;
+				nsoff += chunk;
+			}
+			if (rc) {
+				dev_err(&nd_pfn->dev,
+					"error clearing %x badblocks at %lx\n",
+					num_bad, first_bad);
+				return rc;
+			}
+		}
+	} while (bb_present);
+
+	return 0;
+}
+
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	u64 checksum, offset;
@@ -477,7 +536,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -ENXIO;
 	}
 
-	return 0;
+	return nd_pfn_clear_memmap_errors(nd_pfn);
 }
 EXPORT_SYMBOL(nd_pfn_validate);
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
