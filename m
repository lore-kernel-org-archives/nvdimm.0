Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 822F321161B0E
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 17:08:39 -0700 (PDT)
Subject: [PATCH] libnvdimm, pmem: Fix badblocks population for 'raw' namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 04 Oct 2018 16:56:37 -0700
Message-ID: <153869739732.2904401.10895695693942634646.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jacek Zloch <jacek.zloch@intel.com>, Krzysztof Rusocki <krzysztof.rusocki@intel.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The driver is only initializing bb_res in the devm_memremap_pages()
paths, but the raw namespace case is passing an uninitialized bb_res to
nvdimm_badblocks_populate().

Fixes: e8d513483300 ("memremap: change devm_memremap_pages interface...")
Cc: <stable@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Jacek Zloch <jacek.zloch@intel.com>
Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 6071e2942053..2082ae01b9c8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -421,9 +421,11 @@ static int pmem_attach_disk(struct device *dev,
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pmem->pfn_flags |= PFN_MAP;
 		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
-	} else
+	} else {
 		addr = devm_memremap(dev, pmem->phys_addr,
 				pmem->size, ARCH_MEMREMAP_PMEM);
+		memcpy(&bb_res, &nsio->res, sizeof(bb_res));
+	}
 
 	/*
 	 * At release time the queue must be frozen before

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
