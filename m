Return-Path: <owner-linux-mm@kvack.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v10 3/12] x86, asm: Change is_new_memtype_allowed() for WT
Date: Wed, 27 May 2015 09:18:55 -0600
Message-Id: <1432739944-22633-4-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1432739944-22633-1-git-send-email-toshi.kani@hp.com>
References: <1432739944-22633-1-git-send-email-toshi.kani@hp.com>
Sender: owner-linux-mm@kvack.org
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-nvdimm@lists.01.org, jgross@suse.com, stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br, yigal@plexistor.com, konrad.wilk@oracle.com, Elliott@hp.com, mcgrof@suse.com, hch@lst.de, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

__ioremap_caller() calls reserve_memtype() to set new_pcm
(existing map type if any), and then calls
is_new_memtype_allowed() to verify if converting to new_pcm
is allowed when pcm (request type) is different from new_pcm.

When WT is requested, the caller expects that writes are
ordered and uncached.  Therefore, this patch changes
is_new_memtype_allowed() to disallow the following cases.

 - If the request is WT, mapping type cannot be WB
 - If the request is WT, mapping type cannot be WC

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pgtable.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index fe57e7a..2562e30 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -398,11 +398,17 @@ static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
 	 * requested memtype:
 	 * - request is uncached, return cannot be write-back
 	 * - request is write-combine, return cannot be write-back
+	 * - request is write-through, return cannot be write-back
+	 * - request is write-through, return cannot be write-combine
 	 */
 	if ((pcm == _PAGE_CACHE_MODE_UC_MINUS &&
 	     new_pcm == _PAGE_CACHE_MODE_WB) ||
 	    (pcm == _PAGE_CACHE_MODE_WC &&
-	     new_pcm == _PAGE_CACHE_MODE_WB)) {
+	     new_pcm == _PAGE_CACHE_MODE_WB) ||
+	    (pcm == _PAGE_CACHE_MODE_WT &&
+	     new_pcm == _PAGE_CACHE_MODE_WB) ||
+	    (pcm == _PAGE_CACHE_MODE_WT &&
+	     new_pcm == _PAGE_CACHE_MODE_WC)) {
 		return 0;
 	}
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
