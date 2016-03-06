Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 01DB61A1E2E
 for <linux-nvdimm@lists.01.org>; Sun,  6 Mar 2016 10:17:46 -0800 (PST)
Subject: [PATCH] libnvdimm, pmem: fix ia64 build, use PHYS_PFN
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 06 Mar 2016 10:17:11 -0800
Message-ID: <20160306181711.39220.94549.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: kbuild test robot <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
List-ID: <linux-nvdimm@lists.01.org>

   drivers/nvdimm/pmem.c: In function 'nvdimm_namespace_attach_pfn':
   drivers/nvdimm/pmem.c:367:3: error: implicit declaration of function
   	'__phys_to_pfn' [-Werror=implicit-function-declaration]
   .base_pfn = __phys_to_pfn(nsio->res.start),

ia64 does not provide __phys_to_pfn(), just use the PHYS_PFN() alias.

Cc: Guenter Roeck <linux@roeck-us.net>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0cb450e1b400..74e2569910d8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -407,15 +407,15 @@ static int nvdimm_namespace_detach_pfn(struct nd_namespace_common *ndns)
  */
 static unsigned long init_altmap_base(resource_size_t base)
 {
-	unsigned long base_pfn = __phys_to_pfn(base);
+	unsigned long base_pfn = PHYS_PFN(base);
 
 	return PFN_SECTION_ALIGN_DOWN(base_pfn);
 }
 
 static unsigned long init_altmap_reserve(resource_size_t base)
 {
-	unsigned long reserve = __phys_to_pfn(SZ_8K);
-	unsigned long base_pfn = __phys_to_pfn(base);
+	unsigned long reserve = PHYS_PFN(SZ_8K);
+	unsigned long base_pfn = PHYS_PFN(base);
 
 	reserve += base_pfn - PFN_SECTION_ALIGN_DOWN(base_pfn);
 	return reserve;
@@ -458,7 +458,7 @@ static int __nvdimm_namespace_attach_pfn(struct nd_pfn *nd_pfn)
 					le64_to_cpu(nd_pfn->pfn_sb->npfns),
 					nd_pfn->npfns);
 		altmap = & __altmap;
-		altmap->free = __phys_to_pfn(pmem->data_offset - SZ_8K);
+		altmap->free = PHYS_PFN(pmem->data_offset - SZ_8K);
 		altmap->alloc = 0;
 	} else {
 		rc = -ENXIO;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
