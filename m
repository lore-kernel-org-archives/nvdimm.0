Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net
 (p3plsmtps2ded04.prod.phx3.secureserver.net [208.109.80.198])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C4801A1E08
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 10:24:42 -0700 (PDT)
From: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Subject: [PATCH 1/2] x86: Set up resources correctly on Hyper-V Generation 2
Date: Thu, 18 Aug 2016 12:12:54 -0700
Message-Id: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
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
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <mawilcox@microsoft.com>

The Generation 2 Hyper-V virtual machine does not emulate PCI.
This check causes the call to pcibios_resource_survey() to be skipped,
and pcibios_resource_survey() calls e820_reserve_resources_late(), which
is where PMEM resources are added to the resource tree.  With this patch,
the PMEM devices now show up.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 arch/x86/pci/common.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 7b6a9d1..d39e799 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -516,11 +516,6 @@ void __init pcibios_set_cache_line_size(void)
 
 int __init pcibios_init(void)
 {
-	if (!raw_pci_ops && !raw_pci_ext_ops) {
-		printk(KERN_WARNING "PCI: System does not support PCI\n");
-		return 0;
-	}
-
 	pcibios_set_cache_line_size();
 	pcibios_resource_survey();
 
-- 
2.8.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
