Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B45AB1A1E05
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 08:56:49 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [PATCH] use a nocache copy for bvecs in copy_from_iter_nocache()
Date: Fri,  7 Oct 2016 10:55:11 -0500
Message-Id: <20161007155511.21502-1-brian.boylston@hpe.com>
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
To: linux-nvdimm@lists.01.org
Cc: oliver.moreno@hpe.com, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

copy_from_iter_nocache() is only "nocache" for iovecs.  Enhance it to also
use a nocache copy for bvecs.  This improves performance by 2-3X when
splice()ing to a file in a DAX-mounted, pmem-backed file system.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
Reported-by: Oliver Moreno <oliver.moreno@hpe.com>
---
 arch/x86/include/asm/pmem.h |  6 +++---
 lib/iov_iter.c              | 11 +++++++++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 643eba4..d071f45c 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -73,12 +73,12 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
 }
 
 /*
- * copy_from_iter_nocache() on x86 only uses non-temporal stores for iovec
- * iterators, so for other types (bvec & kvec) we must do a cache write-back.
+ * copy_from_iter_nocache() on x86 uses non-temporal stores for iovec and
+ * bvec iterators, but for kvec we must do a cache write-back.
  */
 static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
 {
-	return iter_is_iovec(i) == false;
+	return (i->type & ITER_KVEC) == ITER_KVEC;
 }
 
 /**
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 7e3138c..df4cb00 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -342,6 +342,13 @@ static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t
 	kunmap_atomic(from);
 }
 
+static void memcpy_from_page_nocache(char *to, struct page *page, size_t offset, size_t len)
+{
+	char *from = kmap_atomic(page);
+	__copy_from_user_inatomic_nocache(to, from, len);
+	kunmap_atomic(from);
+}
+
 static void memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
 {
 	char *to = kmap_atomic(page);
@@ -392,8 +399,8 @@ size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_nocache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
-				 v.bv_offset, v.bv_len),
+		memcpy_from_page_nocache((to += v.bv_len) - v.bv_len,
+					 v.bv_page, v.bv_offset, v.bv_len),
 		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
 
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
