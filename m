Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC1E420969669
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 10:47:44 -0700 (PDT)
Subject: [PATCH] uio, lib: Fix CONFIG_ARCH_HAS_UACCESS_MCSAFE compilation
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 May 2018 10:37:47 -0700
Message-ID: <152726957962.11148.3528187388080177021.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, mingo@kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a common Kconfig CONFIG_ARCH_HAS_UACCESS_MCSAFE that archs can
optionally select, and fixup the declaration of _copy_to_iter_mcsafe().

Fixes: 8780356ef630 ("x86/asm/memcpy_mcsafe: Define copy_to_iter_mcsafe()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Ingo, Thomas, fyi, here is a trivial compilation fixup I will carry in
my tree based on tip/x86/dax. I missed defining the Kconfig symbol, and
my unit test was only dependent on the low level implementation.

 include/linux/uio.h |    2 +-
 lib/Kconfig         |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index f5766e853a77..409c845d4cd3 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -155,7 +155,7 @@ size_t _copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i);
 #endif
 
 #ifdef CONFIG_ARCH_HAS_UACCESS_MCSAFE
-size_t _copy_to_iter_mcsafe(void *addr, size_t bytes, struct iov_iter *i);
+size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i);
 #else
 #define _copy_to_iter_mcsafe _copy_to_iter
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 5fe577673b98..907f6e4f1cf2 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -586,6 +586,9 @@ config ARCH_HAS_PMEM_API
 config ARCH_HAS_UACCESS_FLUSHCACHE
 	bool
 
+config ARCH_HAS_UACCESS_MCSAFE
+	bool
+
 config STACKDEPOT
 	bool
 	select STACKTRACE

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
