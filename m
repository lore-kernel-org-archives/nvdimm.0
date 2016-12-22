Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E8F2823B7
 for <linux-nvdimm@lists.01.org>; Thu, 22 Dec 2016 13:19:07 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 2/4] dax: add stub for pmdp_huge_clear_flush()
Date: Thu, 22 Dec 2016 14:18:54 -0700
Message-Id: <1482441536-14550-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1482441536-14550-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1482441536-14550-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: linux-arch@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add a pmdp_huge_clear_flush() stub for configs that don't define
CONFIG_TRANSPARENT_HUGEPAGE.

We use a WARN_ON_ONCE() instead of a BUILD_BUG() because in the DAX code at
least we do want this compile successfully even for configs without
CONFIG_TRANSPARENT_HUGEPAGE.  It'll be a runtime decision whether we call
this code gets called, based on whether we find DAX PMD entries in our
tree.  We shouldn't ever find such PMD entries for
!CONFIG_TRANSPARENT_HUGEPAGE configs, so this function should never be
called.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/asm-generic/pgtable.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 18af2bc..65e9536 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -178,9 +178,19 @@ extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
 			      unsigned long address,
 			      pmd_t *pmdp);
+#else
+static inline pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pmd_t *pmdp)
+{
+	WARN_ON_ONCE(1);
+	return *pmdp;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_SET_WRPROTECT
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
