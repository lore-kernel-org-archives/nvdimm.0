Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 503F5202E531B
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:37:45 -0800 (PST)
Subject: [PATCH 5/7] libnvdimm/pfn: Remove dax_label_reserve
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:25:06 -0800
Message-ID: <155000670671.348031.8414677031368179860.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The reserve was for an abandoned effort to add label (partitioning
support) to device-dax instances. Remove it.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 108f9f7ed064..110699f4c3e4 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -696,7 +696,6 @@ static void trim_pfn_device(struct nd_pfn *nd_pfn, u32 *start_pad, u32 *end_trun
 
 static int nd_pfn_init(struct nd_pfn *nd_pfn)
 {
-	u32 dax_label_reserve = is_nd_dax(&nd_pfn->dev) ? SZ_128K : 0;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	u32 start_pad, end_trunc, reserve = info_block_reserve();
@@ -754,11 +753,10 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		 * when populating the vmemmap. This *should* be equal to
 		 * PMD_SIZE for most architectures.
 		 */
-		offset = ALIGN(start + reserve + 64 * npfns + dax_label_reserve,
+		offset = ALIGN(start + reserve + 64 * npfns,
 				max(nd_pfn->align, PMD_SIZE)) - start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
-		offset = ALIGN(start + reserve + dax_label_reserve,
-				nd_pfn->align) - start;
+		offset = ALIGN(start + reserve, nd_pfn->align) - start;
 	else
 		return -ENXIO;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
