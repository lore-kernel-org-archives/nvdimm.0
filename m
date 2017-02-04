Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E1D5820B5
 for <linux-nvdimm@lists.01.org>; Sat,  4 Feb 2017 15:14:14 -0800 (PST)
Subject: [PATCH] libnvdimm,
 pfn: fix memmap reservation size versus 4K alignment
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Feb 2017 15:10:08 -0800
Message-ID: <148624980851.20262.10693682076650093248.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When vmemmap_populate() allocates space for the memmap it does so in 2MB
sized chunks. The libnvdimm-pfn driver incorrectly accounts for this
when the alignment of the device is set to 4K. When this happens we
trigger memory allocation failures in altmap_alloc_block_buf() and
trigger warnings of the form:

 WARNING: CPU: 0 PID: 3376 at arch/x86/mm/init_64.c:656 arch_add_memory+0xe4/0xf0
 [..]
 Call Trace:
  dump_stack+0x86/0xc3
  __warn+0xcb/0xf0
  warn_slowpath_null+0x1d/0x20
  arch_add_memory+0xe4/0xf0
  devm_memremap_pages+0x29b/0x4e0

Fixes: 315c562536c4 ("libnvdimm, pfn: add 'align' attribute, default to HPAGE_SIZE")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index a2ac9e641aa9..6c033c9a2f06 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -627,15 +627,12 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	size = resource_size(&nsio->res);
 	npfns = (size - start_pad - end_trunc - SZ_8K) / SZ_4K;
 	if (nd_pfn->mode == PFN_MODE_PMEM) {
-		unsigned long memmap_size;
-
 		/*
 		 * vmemmap_populate_hugepages() allocates the memmap array in
 		 * HPAGE_SIZE chunks.
 		 */
-		memmap_size = ALIGN(64 * npfns, HPAGE_SIZE);
-		offset = ALIGN(start + SZ_8K + memmap_size + dax_label_reserve,
-				nd_pfn->align) - start;
+		offset = ALIGN(start + SZ_8K + 64 * npfns + dax_label_reserve,
+				max(nd_pfn->align, HPAGE_SIZE)) - start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K + dax_label_reserve,
 				nd_pfn->align) - start;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
