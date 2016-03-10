Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 767101A1EF8
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 15:55:53 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 01/14] mmdebug: Always evaluate the arguments to VM_BUG_ON_*
Date: Thu, 10 Mar 2016 18:55:18 -0500
Message-Id: <1457654131-4562-2-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

I recently got the order of arguments to VM_BUG_ON_VMA the wrong way
around, which was only noticable when compiling with CONFIG_DEBUG_VM.
Prevent the next mistake of this kind by making the macros evaluate both
their arguments at compile time (this has no effect on the built kernel).

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 include/linux/mmdebug.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index de7be78..abfc316 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -41,9 +41,24 @@ void dump_mm(const struct mm_struct *mm);
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
-#define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
-#define VM_BUG_ON_VMA(cond, vma) VM_BUG_ON(cond)
-#define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
+#define VM_BUG_ON_PAGE(cond, page)					\
+	do {								\
+		if (0) dump_page(page, "");				\
+		VM_BUG_ON(cond);					\
+	} while (0)
+
+#define VM_BUG_ON_VMA(cond, vma)					\
+	do {								\
+		if (0) dump_vma(vma);					\
+		VM_BUG_ON(cond);					\
+	} while (0)
+
+#define VM_BUG_ON_MM(cond, mm)						\
+	do {								\
+		if (0) dump_mm(mm);					\
+		VM_BUG_ON(cond);					\
+	} while (0)
+
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
-- 
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
