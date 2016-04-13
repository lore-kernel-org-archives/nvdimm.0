Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0949F1A1F19
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 17:19:26 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] pmem: fix BUG() error in pmem.h:48 on X86_32
Date: Tue, 12 Apr 2016 18:10:52 -0600
Message-Id: <1460506252-8596-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

After 'commit fc0c2028135c ("x86, pmem: use memcpy_mcsafe()
for memcpy_from_pmem()")', probing a PMEM device hits the BUG()
error below on X86_32 kernel.

 kernel BUG at include/linux/pmem.h:48!

memcpy_from_pmem() calls arch_memcpy_from_pmem(), which is
unimplemented since CONFIG_ARCH_HAS_PMEM_API is undefined on
X86_32.

Fix the BUG() error by adding default_memcpy_from_pmem().

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/pmem.h |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index ac6d872..57d146f 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -72,6 +72,18 @@ static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
 }
 #endif
 
+static inline bool arch_has_pmem_api(void)
+{
+	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
+}
+
+static inline int default_memcpy_from_pmem(void *dst, void __pmem const *src,
+		size_t size)
+{
+	memcpy(dst, (void __force *) src, size);
+	return 0;
+}
+
 /*
  * memcpy_from_pmem - read from persistent memory with error handling
  * @dst: destination buffer
@@ -83,12 +95,10 @@ static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
 static inline int memcpy_from_pmem(void *dst, void __pmem const *src,
 		size_t size)
 {
-	return arch_memcpy_from_pmem(dst, src, size);
-}
-
-static inline bool arch_has_pmem_api(void)
-{
-	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
+	if (arch_has_pmem_api())
+		return arch_memcpy_from_pmem(dst, src, size);
+	else
+		return default_memcpy_from_pmem(dst, src, size);
 }
 
 /**
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
