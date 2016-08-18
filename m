Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net
 (p3plsmtps2ded03.prod.phx3.secureserver.net [208.109.80.60])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7677E1A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 10:24:42 -0700 (PDT)
From: Matthew Wilcox <mawilcox@linuxonhyperv.com>
Subject: [PATCH 2/2] x86: Turn down the scary 'no PCI' warning
Date: Thu, 18 Aug 2016 12:12:55 -0700
Message-Id: <1471547575-14748-2-git-send-email-mawilcox@linuxonhyperv.com>
In-Reply-To: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
References: <1471547575-14748-1-git-send-email-mawilcox@linuxonhyperv.com>
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

Hyper-V Generation 2 guests do not have PCI hardware.  It is therefore not
'Fatal' to lack PCI config space, and those booting with the 'quiet' option
do not need to see a message at all.  I deem this to be 'informational'
rather than 'normal but significant', at least on some hardware.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 arch/x86/pci/init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index adb62aa..595840a 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -32,8 +32,7 @@ static __init int pci_arch_init(void)
 	pci_direct_init(type);
 #endif
 	if (!raw_pci_ops && !raw_pci_ext_ops)
-		printk(KERN_ERR
-		"PCI: Fatal: No config space access function found\n");
+		pr_info("PCI: No config space access function found\n");
 
 	dmi_check_pciprobe();
 
-- 
2.8.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
