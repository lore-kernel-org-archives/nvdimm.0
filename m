Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0F7620216B77
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 06:36:35 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v6 3/7] libnvdimm/pfn_dev: Add a build check to make sure we
 notice when struct page size change
Date: Mon, 19 Aug 2019 19:04:47 +0530
Message-Id: <20190819133451.19737-4-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190819133451.19737-1-aneesh.kumar@linux.ibm.com>
References: <20190819133451.19737-1-aneesh.kumar@linux.ibm.com>
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
To: dan.j.williams@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Namespaces created with PFN_MODE_PMEM mode stores struct page in the reserve
block area. We need to make sure we account for the right struct page
size while doing this. Instead of directly depending on sizeof(struct page)
which can change based on different kernel config option, use the max struct
page size (64) while calculating the reserve block area. This makes sure pmem
device can be used across kernels built with different configs.

If the above assumption of max struct page size change, we need to update the
reserve block allocation space for new namespaces created.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/nd.h       |  4 ++++
 drivers/nvdimm/pfn_devs.c | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 1b9955651379..e89af4b2d8e9 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -375,6 +375,10 @@ unsigned int pmem_sector_size(struct nd_namespace_common *ndns);
 void nvdimm_badblocks_populate(struct nd_region *nd_region,
 		struct badblocks *bb, const struct resource *res);
 #if IS_ENABLED(CONFIG_ND_CLAIM)
+
+/* max struct page size independent of kernel config */
+#define MAX_STRUCT_PAGE_SIZE 64
+
 int nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap);
 int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio);
 void devm_nsio_disable(struct device *dev, struct nd_namespace_io *nsio);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 3e7b11cf1aae..cd120feb9213 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -701,8 +701,16 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		 * The altmap should be padded out to the block size used
 		 * when populating the vmemmap. This *should* be equal to
 		 * PMD_SIZE for most architectures.
+		 *
+		 * Also make sure size of struct page is less than 64. We
+		 * want to make sure we use large enough size here so that
+		 * we don't have a dynamic reserve space depending on
+		 * struct page size. But we also want to make sure we notice
+		 * when we end up adding new elements to struct page.
 		 */
-		offset = ALIGN(start + SZ_8K + 64 * npfns, align) - start;
+		BUILD_BUG_ON(sizeof(struct page) > MAX_STRUCT_PAGE_SIZE);
+		offset = ALIGN(start + SZ_8K + MAX_STRUCT_PAGE_SIZE * npfns, align)
+			- start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K, align) - start;
 	else
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
