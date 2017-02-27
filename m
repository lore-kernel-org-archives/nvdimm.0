Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C721481F3A
 for <linux-nvdimm@lists.01.org>; Mon, 27 Feb 2017 08:51:33 -0800 (PST)
Subject: [PATCH] fs, dax: fix build warning for !CONFIG_FS_DAX_PMD case for
 dax_iomap_pmd_fault
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 27 Feb 2017 09:51:32 -0700
Message-ID: <148821429251.38263.11870148981890888722.stgit@djiang5-desk3.ch.intel.com>
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
To: akpm@linux-foundation.org
Cc: sfr@canb.auug.org.au, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, kirill.shutemov@linux.intel.com, jack@suse.com, torvalds@linux-foundation.org, vbabka@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

Stephen reported:
With just Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
produced this warning:

fs/dax.c: In function 'dax_iomap_fault':
fs/dax.c:1462:35: warning: passing argument 2 of 'dax_iomap_pmd_fault' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
   return dax_iomap_pmd_fault(vmf, ops);
                                   ^
fs/dax.c:1439:12: note: expected 'struct iomap_ops *' but argument is of type 'const struct iomap_ops *'
 static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
            ^

Introduced by

  commit a2d581675d48 ("mm,fs,dax: change ->pmd_fault to ->huge_fault")

which missed fixing up the !CONFIG_FS_DAX_PMD case.


Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5ae8b71..7436c98 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1436,7 +1436,8 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	return result;
 }
 #else
-static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
+static int dax_iomap_pmd_fault(struct vm_fault *vmf,
+			       const struct iomap_ops *ops)
 {
 	return VM_FAULT_FALLBACK;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
