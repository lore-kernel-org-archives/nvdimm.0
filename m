Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id E10111A1ED5
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 13:53:42 -0800 (PST)
Subject: [PATCH v2 1/3] libnvdimm,
 pmem: fix 'pfn' support for section-misaligned namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 03 Mar 2016 13:53:09 -0800
Message-ID: <20160303215309.1014.4943.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160303215304.1014.69931.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160303215304.1014.69931.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The altmap for a section-misaligned namespace needs to arrange for the
base_pfn to be section-aligned.  As a result the 'reserve' region (pfns
from base that do not have a struct page) must be increased.  Otherwise
we trip the altmap validation check in __add_pages:

	if (altmap->base_pfn != phys_start_pfn
			|| vmem_altmap_offset(altmap) > nr_pages) {
		pr_warn_once("memory add fail, invalid altmap\n");
		return -EINVAL;
	}

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn.h  |   13 +++++++++++++
 drivers/nvdimm/pmem.c |   24 ++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index cc243754acef..6ee707e5b279 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -15,6 +15,7 @@
 #define __NVDIMM_PFN_H
 
 #include <linux/types.h>
+#include <linux/mmzone.h>
 
 #define PFN_SIG_LEN 16
 #define PFN_SIG "NVDIMM_PFN_INFO\0"
@@ -32,4 +33,16 @@ struct nd_pfn_sb {
 	u8 padding[4012];
 	__le64 checksum;
 };
+
+#ifdef CONFIG_SPARSEMEM
+#define PFN_SECTION_ALIGN_DOWN(x) SECTION_ALIGN_DOWN(x)
+#define PFN_SECTION_ALIGN_UP(x) SECTION_ALIGN_UP(x)
+#else
+/*
+ * In this case ZONE_DEVICE=n and we will disable 'pfn' device support,
+ * but we still want pmem to compile.
+ */
+#define PFN_SECTION_ALIGN_DOWN(x) (x)
+#define PFN_SECTION_ALIGN_UP(x) (x)
+#endif
 #endif /* __NVDIMM_PFN_H */
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 7edf31671dab..68a20b2e3d03 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -356,6 +356,26 @@ static int nvdimm_namespace_detach_pfn(struct nd_namespace_common *ndns)
 	return 0;
 }
 
+/*
+ * We hotplug memory at section granularity, pad the reserved area from
+ * the previous section base to the namespace base address.
+ */
+static unsigned long init_altmap_base(resource_size_t base)
+{
+	unsigned long base_pfn = __phys_to_pfn(base);
+
+	return PFN_SECTION_ALIGN_DOWN(base_pfn);
+}
+
+static unsigned long init_altmap_reserve(resource_size_t base)
+{
+	unsigned long reserve = __phys_to_pfn(SZ_8K);
+	unsigned long base_pfn = __phys_to_pfn(base);
+
+	reserve += base_pfn - PFN_SECTION_ALIGN_DOWN(base_pfn);
+	return reserve;
+}
+
 static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
@@ -369,8 +389,8 @@ static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
 	phys_addr_t offset;
 	int rc;
 	struct vmem_altmap __altmap = {
-		.base_pfn = __phys_to_pfn(nsio->res.start),
-		.reserve = __phys_to_pfn(SZ_8K),
+		.base_pfn = init_altmap_base(nsio->res.start),
+		.reserve = init_altmap_reserve(nsio->res.start),
 	};
 
 	if (!nd_pfn->uuid || !nd_pfn->ndns)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
