Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3133D81F5C
 for <linux-nvdimm@lists.01.org>; Mon, 27 Feb 2017 13:44:42 -0800 (PST)
Subject: [PATCH] mm,
 x86: fix HIGHMEM64 && PARAVIRT build config for native_pud_clear()
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 27 Feb 2017 14:44:40 -0700
Message-ID: <148823188084.56076.17451228917824355200.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alexander.kapshuk@gmail.com, linux-nvdimm@lists.01.org, kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, linux-mm@kvack.org, vbabka@suse.cz, jack@suse.com, boris.ostrovsky@oracle.com, labbott@redhat.com, mawilcox@microsoft.com
List-ID: <linux-nvdimm@lists.01.org>

Looks like I also missed the build config that includes
CONFIG_HIGHMEM64G && CONFIG_PARAVIRT to export the native_pud_clear()
dummy function.

Fix: commit e5d56efc ("mm,x86: fix SMP x86 32bit build for native_pud_clear()")

Reported-by: Laura Abbott <labbott@redhat.com>
Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/include/asm/pgtable-3level.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 8f50fb3..72277b1 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -121,7 +121,8 @@ static inline void native_pmd_clear(pmd_t *pmd)
 	*(tmp + 1) = 0;
 }
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) || (defined(CONFIG_HIGHMEM64G) && \
+		defined(CONFIG_PARAVIRT))
 static inline void native_pud_clear(pud_t *pudp)
 {
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
