Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 90D9E1A1E37
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:37:36 -0700 (PDT)
Subject: [PATCH 3/7] libnvdimm,
 dax: reserve space to store labels for device-dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:35:26 -0700
Message-ID: <146274692623.10891.5503895995224585718.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146274690999.10891.10714722986208180484.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146274690999.10891.10714722986208180484.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We may want to subdivide a device-dax range into multiple devices so
that each can have separate permissions or naming.  Reserve 128K of
label space by default so we have the capability of making allocation
decisions persistent.  This reservation is not something we can add
later since it would result in the default size of a device-dax range
changing between kernel versions.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 6ade2eb7615d..ca396c8f2cd5 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -540,6 +540,7 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 
 static int nd_pfn_init(struct nd_pfn *nd_pfn)
 {
+	u32 dax_label_reserve = is_nd_dax(&nd_pfn->dev) ? SZ_128K : 0;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	u32 start_pad = 0, end_trunc = 0;
 	resource_size_t start, size;
@@ -606,10 +607,11 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	size = resource_size(&nsio->res);
 	npfns = (size - start_pad - end_trunc - SZ_8K) / SZ_4K;
 	if (nd_pfn->mode == PFN_MODE_PMEM)
-		offset = ALIGN(start + SZ_8K + 64 * npfns, nd_pfn->align)
-			- start;
+		offset = ALIGN(start + SZ_8K + 64 * npfns + dax_label_reserve,
+				nd_pfn->align) - start;
 	else if (nd_pfn->mode == PFN_MODE_RAM)
-		offset = ALIGN(start + SZ_8K, nd_pfn->align) - start;
+		offset = ALIGN(start + SZ_8K + dax_label_reserve,
+				nd_pfn->align) - start;
 	else
 		return -ENXIO;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
