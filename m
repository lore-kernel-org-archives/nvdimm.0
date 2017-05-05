Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8B0F21A134AE
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 23:05:31 -0700 (PDT)
Subject: [PATCH] libnvdimm, pfn: fix 'npfns' vs section alignment
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 04 May 2017 22:59:39 -0700
Message-ID: <149396397961.31886.15525541367319370382.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Anisha Allada <anisha.allada@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Fix failures to create namespaces due to the vmem_altmap not advertising
enough free space to store the memmap.

 WARNING: CPU: 15 PID: 8022 at arch/x86/mm/init_64.c:656 arch_add_memory+0xde/0xf0
 [..]
 Call Trace:
  dump_stack+0x63/0x83
  __warn+0xcb/0xf0
  warn_slowpath_null+0x1d/0x20
  arch_add_memory+0xde/0xf0
  devm_memremap_pages+0x244/0x440
  pmem_attach_disk+0x37e/0x490 [nd_pmem]
  nd_pmem_probe+0x7e/0xa0 [nd_pmem]
  nvdimm_bus_probe+0x71/0x120 [libnvdimm]
  driver_probe_device+0x2bb/0x460
  bind_store+0x114/0x160
  drv_attr_store+0x25/0x30

In commit 658922e57b84 "libnvdimm, pfn: fix memmap reservation sizing"
we arranged for the capacity to be allocated, but failed to also update
the 'npfns' parameter. This leads to cases where there is enough
capacity reserved to hold all the allocated sections, but
vmemmap_populate_hugepages() still encounters -ENOMEM from
altmap_alloc_block_buf().

This fix is a stop-gap until we can teach the core memory hotplug
implementation to permit sub-section hotplug.

Cc: <stable@vger.kernel.org>
Fixes: 658922e57b84 ("libnvdimm, pfn: fix memmap reservation sizing")
Reported-by: Anisha Allada <anisha.allada@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index c38566f4da7d..335c8175410b 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -538,7 +538,8 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 		nd_pfn->npfns = le64_to_cpu(pfn_sb->npfns);
 		altmap = NULL;
 	} else if (nd_pfn->mode == PFN_MODE_PMEM) {
-		nd_pfn->npfns = (resource_size(res) - offset) / PAGE_SIZE;
+		nd_pfn->npfns = PFN_SECTION_ALIGN_UP((resource_size(res)
+					- offset) / PAGE_SIZE);
 		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
 			dev_info(&nd_pfn->dev,
 					"number of pfns truncated from %lld to %ld\n",
@@ -625,7 +626,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	 */
 	start += start_pad;
 	size = resource_size(&nsio->res);
-	npfns = (size - start_pad - end_trunc - SZ_8K) / SZ_4K;
+	npfns = PFN_SECTION_ALIGN_UP((size - start_pad - end_trunc - SZ_8K)
+			/ PAGE_SIZE);
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
 		/*
 		 * vmemmap_populate_hugepages() allocates the memmap array in

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
