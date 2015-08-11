Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 06/10] libnvdimm,
 pmem: push call to ioremap_cache out of line
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Aug 2015 23:38:23 -0400
Message-ID: <20150811033823.4987.83902.stgit@otcpl-bsw-rvp-2.jf.intel.com>
In-Reply-To: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() push its usage into arch
code where it deleted in a later globabl conversion of ioremap_cache()
to arch_memremap().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/io.h         |    7 +------
 arch/x86/mm/ioremap.c             |    6 ++++++
 tools/testing/nvdimm/Kbuild       |    2 +-
 tools/testing/nvdimm/test/iomap.c |    6 +++---
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index cc9c61bc1abe..8aeb6456188a 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -248,12 +248,7 @@ static inline void flush_write_buffers(void)
 #endif
 }
 
-static inline void __pmem *arch_memremap_pmem(resource_size_t offset,
-	unsigned long size)
-{
-	return (void __force __pmem *) ioremap_cache(offset, size);
-}
-
+void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size);
 #endif /* __KERNEL__ */
 
 extern void native_io_delay(void);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index b9c78f3bcd67..c0734030e9db 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -317,6 +317,12 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_cache);
 
+void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size)
+{
+	return (void __force __pmem *) ioremap_cache(offset, size);
+}
+EXPORT_SYMBOL(arch_memremap_pmem);
+
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 				unsigned long prot_val)
 {
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index f56914c7929b..de2912ea78e8 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -1,7 +1,7 @@
 ldflags-y += --wrap=ioremap_wt
 ldflags-y += --wrap=ioremap_wc
 ldflags-y += --wrap=devm_ioremap_nocache
-ldflags-y += --wrap=ioremap_cache
+ldflags-y += --wrap=arch_memremap_pmem
 ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
 ldflags-y += --wrap=__request_region
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 64bfaa50831c..f8486f98f860 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -80,11 +80,11 @@ void __iomem *__wrap_devm_ioremap_nocache(struct device *dev,
 }
 EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
 
-void __iomem *__wrap_ioremap_cache(resource_size_t offset, unsigned long size)
+void *__wrap_arch_memremap_pmem(resource_size_t offset, size_t size)
 {
-	return __nfit_test_ioremap(offset, size, ioremap_cache);
+	return __nfit_test_ioremap(offset, size, arch_memremap_pmem);
 }
-EXPORT_SYMBOL(__wrap_ioremap_cache);
+EXPORT_SYMBOL(__wrap_arch_memremap_pmem);
 
 void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 {

