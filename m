Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7071E21AE2657
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 02:55:13 -0700 (PDT)
Received: by mail-pg0-x244.google.com with SMTP id u36so3699480pgn.3
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 02:56:43 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] libnvdimm: Stop using HPAGE_SIZE
Date: Tue, 27 Jun 2017 19:56:33 +1000
Message-Id: <20170627095633.6508-1-oohall@gmail.com>
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

Currently libnvdimm uses HPAGE_SIZE as the default alignment for DAX and
PFN devices. HPAGE_SIZE is the default hugetlbfs page size and when
hugetlbfs is disabled it defaults to PAGE_SIZE. Given DAX has more
in common with THP than hugetlbfs we should proably be using
HPAGE_PMD_SIZE, but this is undefined when THP is disabled so lets just
give it a new name.

The other usage of HPAGE_SIZE in libnvdimm is when determining how large
the altmap should be. For the reasons mentioned above it doesn't really
make sense to use HPAGE_SIZE here either. PMD_SIZE seems to be safe to
use in generic code and it happens to match the vmemmap allocation block
on x86 and Power. It's still a hack, but it's a slightly nicer hack.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 drivers/nvdimm/nd.h       | 7 +++++++
 drivers/nvdimm/pfn_devs.c | 9 +++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 8cabd836df0e..714e3337b609 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -281,6 +281,13 @@ static inline struct device *nd_btt_create(struct nd_region *nd_region)
 
 struct nd_pfn *to_nd_pfn(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_PFN)
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define PFN_DEFAULT_ALIGNMENT HPAGE_PMD_SIZE
+#else
+#define PFN_DEFAULT_ALIGNMENT PAGE_SIZE
+#endif
+
 int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_pfn(struct device *dev);
 struct device *nd_pfn_create(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 5fcb6f5b22a2..2ae9a000b090 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -290,7 +290,7 @@ struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
 		return NULL;
 
 	nd_pfn->mode = PFN_MODE_NONE;
-	nd_pfn->align = HPAGE_SIZE;
+	nd_pfn->align = PFN_DEFAULT_ALIGNMENT;
 	dev = &nd_pfn->dev;
 	device_initialize(&nd_pfn->dev);
 	if (ndns && !__nd_attach_ndns(&nd_pfn->dev, ndns, &nd_pfn->ndns)) {
@@ -638,11 +638,12 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 			/ PAGE_SIZE);
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
 		/*
-		 * vmemmap_populate_hugepages() allocates the memmap array in
-		 * HPAGE_SIZE chunks.
+		 * The altmap should be padded out to the block size used
+		 * when populating the vmemmap. This *should* be equal to
+		 * PMD_SIZE for most architectures.
 		 */
 		offset = ALIGN(start + SZ_8K + 64 * npfns + dax_label_reserve,
-				max(nd_pfn->align, HPAGE_SIZE)) - start;
+				max(nd_pfn->align, PMD_SIZE)) - start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K + dax_label_reserve,
 				nd_pfn->align) - start;
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
