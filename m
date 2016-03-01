Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 48FD11A1E3F
 for <linux-nvdimm@lists.01.org>; Mon, 29 Feb 2016 18:56:57 -0800 (PST)
Subject: [PATCH 1/2] libnvdimm,
 pmem: fix 'pfn' support for section-misaligned namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Feb 2016 18:56:26 -0800
Message-ID: <20160301025626.12812.4840.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160301025620.12812.87268.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160301025620.12812.87268.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
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
 drivers/nvdimm/pmem.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index efc2a5e671c6..6a6283ab974c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -356,6 +356,31 @@ static int nvdimm_namespace_detach_pfn(struct nd_namespace_common *ndns)
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
+#ifdef CONFIG_SPARSEMEM
+	base_pfn = SECTION_ALIGN_DOWN(base_pfn);
+#endif
+	return base_pfn;
+}
+
+static unsigned long init_altmap_reserve(resource_size_t base)
+{
+	unsigned long base_pfn = __phys_to_pfn(base);
+	unsigned long reserve = __phys_to_pfn(SZ_8K);
+
+#ifdef CONFIG_SPARSEMEM
+	reserve += base_pfn - SECTION_ALIGN_DOWN(base_pfn);
+#endif
+	return reserve;
+}
+
 static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
@@ -369,8 +394,8 @@ static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
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
