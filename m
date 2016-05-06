Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 71C6B1A1E26
 for <linux-nvdimm@lists.01.org>; Fri,  6 May 2016 10:27:26 -0700 (PDT)
Subject: [PATCH] libnvdimm, pfn: fix ARCH=alpha allmodconfig build failure
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 May 2016 10:26:38 -0700
Message-ID: <146255559866.32780.5399379827409805110.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Guenter Roeck <guenter@roeck-us.net>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

I had relied on the kbuild robot for cross build coverage, however it
only builds alpha_defconfig.  Switch from HPAGE_SIZE to PMD_SIZE, which
is more widely defined.

Fixes: 658922e57b84 ("libnvdimm, pfn: fix memmap reservation sizing")
Cc: <stable@vger.kernel.org>
Reported-by: Guenter Roeck <guenter@roeck-us.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5101f3ab4f29..e5a8bf032ec9 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -404,7 +404,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		 * vmemmap_populate_hugepages() allocates the memmap array in
 		 * HPAGE_SIZE chunks.
 		 */
-		memmap_size = ALIGN(64 * npfns, HPAGE_SIZE);
+		memmap_size = ALIGN(64 * npfns, PMD_SIZE);
 		offset = ALIGN(start + SZ_8K + memmap_size, nd_pfn->align)
 			- start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
