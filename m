Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DA4D20957B07
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 17:16:29 -0700 (PDT)
Subject: [PATCH v3 5/9] x86, memcpy_mcsafe: define copy_to_iter_mcsafe()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 03 May 2018 17:06:31 -0700
Message-ID: <152539239150.31796.9189779163576449784.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152539236455.31796.7516599166555186700.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152539236455.31796.7516599166555186700.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: tony.luck@intel.com, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, x86@kernel.org, hch@lst.de, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Use the updated memcpy_mcsafe() implementation to define
copy_user_mcsafe() and copy_to_iter_mcsafe(). The most significant
difference from typical copy_to_iter() is that the ITER_KVEC and
ITER_BVEC iterator types can fail to complete a full transfer.

Cc: <x86@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/uaccess_64.h |   11 +++++++
 include/linux/uio.h               |   15 +++++++++
 lib/iov_iter.c                    |   61 +++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c07f492b871a..6ca22706cd64 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -60,6 +60,7 @@ config X86
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_REFCOUNT
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
+	select ARCH_HAS_UACCESS_MCSAFE		if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index c63efc07891f..62acb613114b 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -47,6 +47,17 @@ copy_user_generic(void *to, const void *from, unsigned len)
 }
 
 static __always_inline __must_check unsigned long
+copy_to_user_mcsafe(void *to, const void *from, unsigned len)
+{
+	unsigned long ret;
+
+	__uaccess_begin();
+	ret = memcpy_mcsafe(to, from, len);
+	__uaccess_end();
+	return ret;
+}
+
+static __always_inline __must_check unsigned long
 raw_copy_from_user(void *dst, const void __user *src, unsigned long size)
 {
 	int ret = 0;
diff --git a/include/linux/uio.h b/include/linux/uio.h
index e67e12adb136..f5766e853a77 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -154,6 +154,12 @@ size_t _copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i);
 #define _copy_from_iter_flushcache _copy_from_iter_nocache
 #endif
 
+#ifdef CONFIG_ARCH_HAS_UACCESS_MCSAFE
+size_t _copy_to_iter_mcsafe(void *addr, size_t bytes, struct iov_iter *i);
+#else
+#define _copy_to_iter_mcsafe _copy_to_iter
+#endif
+
 static __always_inline __must_check
 size_t copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 {
@@ -163,6 +169,15 @@ size_t copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 		return _copy_from_iter_flushcache(addr, bytes, i);
 }
 
+static __always_inline __must_check
+size_t copy_to_iter_mcsafe(void *addr, size_t bytes, struct iov_iter *i)
+{
+	if (unlikely(!check_copy_size(addr, bytes, false)))
+		return 0;
+	else
+		return _copy_to_iter_mcsafe(addr, bytes, i);
+}
+
 size_t iov_iter_zero(size_t bytes, struct iov_iter *);
 unsigned long iov_iter_alignment(const struct iov_iter *i);
 unsigned long iov_iter_gap_alignment(const struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 970212670b6a..70ebc8ede143 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -573,6 +573,67 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 }
 EXPORT_SYMBOL(_copy_to_iter);
 
+#ifdef CONFIG_ARCH_HAS_UACCESS_MCSAFE
+static int copyout_mcsafe(void __user *to, const void *from, size_t n)
+{
+	if (access_ok(VERIFY_WRITE, to, n)) {
+		kasan_check_read(from, n);
+		n = copy_to_user_mcsafe((__force void *) to, from, n);
+	}
+	return n;
+}
+
+static unsigned long memcpy_mcsafe_to_page(struct page *page, size_t offset,
+		const char *from, size_t len)
+{
+	unsigned long ret;
+	char *to;
+
+	to = kmap_atomic(page);
+	ret = memcpy_mcsafe(to + offset, from, len);
+	kunmap_atomic(to);
+
+	return ret;
+}
+
+size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
+{
+	const char *from = addr;
+	unsigned long rem, curr_addr, s_addr = (unsigned long) addr;
+
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return 0;
+	}
+	if (iter_is_iovec(i))
+		might_fault();
+	iterate_and_advance(i, bytes, v,
+		copyout_mcsafe(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
+		({
+		rem = memcpy_mcsafe_to_page(v.bv_page, v.bv_offset,
+                               (from += v.bv_len) - v.bv_len, v.bv_len);
+		if (rem) {
+			curr_addr = (unsigned long) from;
+			bytes = curr_addr - s_addr - rem;
+			return bytes;
+		}
+		}),
+		({
+		rem = memcpy_mcsafe(v.iov_base, (from += v.iov_len) - v.iov_len,
+				v.iov_len);
+		if (rem) {
+			curr_addr = (unsigned long) from;
+			bytes = curr_addr - s_addr - rem;
+			return bytes;
+		}
+		})
+	)
+
+	return bytes;
+}
+EXPORT_SYMBOL_GPL(_copy_to_iter_mcsafe);
+#endif /* CONFIG_ARCH_HAS_UACCESS_MCSAFE */
+
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
 	char *to = addr;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
