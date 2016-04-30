Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 5BBB01A1F86
 for <linux-nvdimm@lists.01.org>; Sat, 30 Apr 2016 14:03:12 -0700 (PDT)
Subject: [PATCH] libnvdimm, pfn: fix memmap reservation sizing
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Apr 2016 14:02:23 -0700
Message-ID: <146205014370.20579.17366708223180896686.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Namratha Kothapalli <namratha.n.kothapalli@intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When configuring a pfn-device instance to allocate the memmap array it
needs to account for the fact that vmemmap_populate_hugepages()
allocates struct page blocks in HPAGE_SIZE chunks.  We need to align the
reserved area size to 2MB otherwise arch_add_memory() runs out of memory
while establishing the memmap:

 WARNING: CPU: 0 PID: 496 at arch/x86/mm/init_64.c:704 arch_add_memory+0xe7/0xf0
 [..]
 Call Trace:
  [<ffffffff8148bdb3>] dump_stack+0x85/0xc2
  [<ffffffff810a749b>] __warn+0xcb/0xf0
  [<ffffffff810a75cd>] warn_slowpath_null+0x1d/0x20
  [<ffffffff8106a497>] arch_add_memory+0xe7/0xf0
  [<ffffffff811d2097>] devm_memremap_pages+0x287/0x450
  [<ffffffff811d1ffa>] ? devm_memremap_pages+0x1ea/0x450
  [<ffffffffa0000298>] __wrap_devm_memremap_pages+0x58/0x70 [nfit_test_iomap]
  [<ffffffffa0047a58>] pmem_attach_disk+0x318/0x420 [nd_pmem]
  [<ffffffffa0047bcf>] nd_pmem_probe+0x6f/0x90 [nd_pmem]
  [<ffffffffa0009469>] nvdimm_bus_probe+0x69/0x110 [libnvdimm]
 [..]
  ndbus0: nd_pmem.probe(pfn3.0) = -12
 nd_pmem: probe of pfn3.0 failed with error -12
libndctl: ndctl_pfn_enable: pfn3.0: failed to enable

Reported-by: Namratha Kothapalli <namratha.n.kothapalli@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f798899338ed..5101f3ab4f29 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -397,10 +397,17 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	 */
 	start += start_pad;
 	npfns = (pmem->size - start_pad - end_trunc - SZ_8K) / SZ_4K;
-	if (nd_pfn->mode == PFN_MODE_PMEM)
-		offset = ALIGN(start + SZ_8K + 64 * npfns, nd_pfn->align)
+	if (nd_pfn->mode == PFN_MODE_PMEM) {
+		unsigned long memmap_size;
+
+		/*
+		 * vmemmap_populate_hugepages() allocates the memmap array in
+		 * HPAGE_SIZE chunks.
+		 */
+		memmap_size = ALIGN(64 * npfns, HPAGE_SIZE);
+		offset = ALIGN(start + SZ_8K + memmap_size, nd_pfn->align)
 			- start;
-	else if (nd_pfn->mode == PFN_MODE_RAM)
+	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K, nd_pfn->align) - start;
 	else
 		goto err;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
