Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43F5020954CCE
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 20:51:58 -0800 (PST)
Received: by mail-pl0-x242.google.com with SMTP id s13-v6so11234312plq.6
 for <linux-nvdimm@lists.01.org>; Mon, 05 Mar 2018 20:58:11 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] kernel/memremap: Remove stale devres_free() call
Date: Tue,  6 Mar 2018 15:56:47 +1100
Message-Id: <20180306045647.7784-1-oohall@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

devm_memremap_pages() was re-worked in e8d513483300 to take a caller
allocated struct dev_pagemap as a function parameter. A call to
devres_free() was left in the error cleanup path which results in
a kernel panic if the remap fails for some reason. Remove it
to fix the panic and let devm_memremap_pages() fail gracefully.

Fixes: e8d513483300 ("memremap: change devm_memremap_pages interface to use struct dev_pagemap")
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
Both in-tree users of devm_memremap_pages() embed dev_pagemap into other
structures so this shouldn't cause any leaks. Logan's p2p series does
add one usage that assumes pgmap will be freed on error so that'll
need fixing.
---
 kernel/memremap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 4dd4274cabe2..895e6b76b25e 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -427,7 +427,6 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
  err_pfn_remap:
  err_radix:
 	pgmap_radix_release(res, pgoff);
-	devres_free(pgmap);
 	return ERR_PTR(error);
 }
 EXPORT_SYMBOL(devm_memremap_pages);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
