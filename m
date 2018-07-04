Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 698622033736C
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 14:51:19 -0700 (PDT)
Subject: [PATCH v5 11/11] libnvdimm,
 pmem: Restore page attributes when clearing errors
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 14:41:21 -0700
Message-ID: <153074048162.27838.14847952115074744540.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Use clear_mce_nospec() to restore WB mode for the kernel linear mapping
of a pmem page that was marked 'HWPoison'. A page with 'HWPoison' set
has also been marked UC in PAT (page attribute table) via
set_mce_nospec() to prevent speculative retrievals of poison.

The 'HWPoison' flag is only cleared when overwriting an entire page.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   26 ++++++++++++++++++++++++++
 drivers/nvdimm/pmem.h |   13 +++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8b1fd7f1a224..55c7a69751d3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -20,6 +20,7 @@
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/set_memory.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/badblocks.h>
@@ -51,6 +52,30 @@ static struct nd_region *to_region(struct pmem_device *pmem)
 	return to_nd_region(to_dev(pmem)->parent);
 }
 
+static void hwpoison_clear(struct pmem_device *pmem,
+		phys_addr_t phys, unsigned int len)
+{
+	unsigned long pfn_start, pfn_end, pfn;
+
+	/* only pmem in the linear map supports HWPoison */
+	if (is_vmalloc_addr(pmem->virt_addr))
+		return;
+
+	pfn_start = PHYS_PFN(phys);
+	pfn_end = pfn_start + PHYS_PFN(len);
+	for (pfn = pfn_start; pfn < pfn_end; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		/*
+		 * Note, no need to hold a get_dev_pagemap() reference
+		 * here since we're in the driver I/O path and
+		 * outstanding I/O requests pin the dev_pagemap.
+		 */
+		if (test_and_clear_pmem_poison(page))
+			clear_mce_nospec(pfn);
+	}
+}
+
 static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 		phys_addr_t offset, unsigned int len)
 {
@@ -65,6 +90,7 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 	if (cleared < len)
 		rc = BLK_STS_IOERR;
 	if (cleared > 0 && cleared / 512) {
+		hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
 		cleared /= 512;
 		dev_dbg(dev, "%#llx clear %ld sector%s\n",
 				(unsigned long long) sector, cleared,
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index a64ebc78b5df..59cfe13ea8a8 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NVDIMM_PMEM_H__
 #define __NVDIMM_PMEM_H__
+#include <linux/page-flags.h>
 #include <linux/badblocks.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
@@ -27,4 +28,16 @@ struct pmem_device {
 
 long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
+
+#ifdef CONFIG_MEMORY_FAILURE
+static inline bool test_and_clear_pmem_poison(struct page *page)
+{
+	return TestClearPageHWPoison(page);
+}
+#else
+static inline bool test_and_clear_pmem_poison(struct page *page)
+{
+	return false;
+}
+#endif
 #endif /* __NVDIMM_PMEM_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
