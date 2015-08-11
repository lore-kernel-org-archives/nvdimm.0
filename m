Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 07/10] pmem: switch from ioremap_wt to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Aug 2015 23:38:28 -0400
Message-ID: <20150811033828.4987.46863.stgit@otcpl-bsw-rvp-2.jf.intel.com>
In-Reply-To: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_wt() convert its usage in
the PMEM API to memremap.

Acked-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/pmem.h              |    2 +-
 tools/testing/nvdimm/Kbuild       |    4 ++--
 tools/testing/nvdimm/test/iomap.c |   34 +++++++++++++++++++++++++---------
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index d2114045a6c4..1bf74c735fa0 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -94,7 +94,7 @@ static void default_memcpy_to_pmem(void __pmem *dst, const void *src,
 static void __pmem *default_memremap_pmem(resource_size_t offset,
 		unsigned long size)
 {
-	return (void __pmem __force *)ioremap_wt(offset, size);
+	return (void __pmem *) memremap(offset, size, MEMREMAP_WT);
 }
 
 /**
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index de2912ea78e8..8032a49f7873 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -1,7 +1,7 @@
-ldflags-y += --wrap=ioremap_wt
 ldflags-y += --wrap=ioremap_wc
 ldflags-y += --wrap=devm_ioremap_nocache
-ldflags-y += --wrap=arch_memremap_pmem
+ldflags-y += --wrap=memremap
+ldflags-y += --wrap=memunmap
 ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
 ldflags-y += --wrap=__request_region
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index f8486f98f860..21288f34a5ca 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -80,11 +80,20 @@ void __iomem *__wrap_devm_ioremap_nocache(struct device *dev,
 }
 EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
 
-void *__wrap_arch_memremap_pmem(resource_size_t offset, size_t size)
+void *__wrap_memremap(resource_size_t offset, size_t size,
+		unsigned long flags)
 {
-	return __nfit_test_ioremap(offset, size, arch_memremap_pmem);
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res(offset);
+	rcu_read_unlock();
+	if (nfit_res)
+		return (void __iomem *) nfit_res->buf + offset
+			- nfit_res->res->start;
+	return memremap(offset, size, flags);
 }
-EXPORT_SYMBOL(__wrap_arch_memremap_pmem);
+EXPORT_SYMBOL(__wrap_memremap);
 
 void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 {
@@ -92,12 +101,6 @@ void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 }
 EXPORT_SYMBOL(__wrap_ioremap_nocache);
 
-void __iomem *__wrap_ioremap_wt(resource_size_t offset, unsigned long size)
-{
-	return __nfit_test_ioremap(offset, size, ioremap_wt);
-}
-EXPORT_SYMBOL(__wrap_ioremap_wt);
-
 void __iomem *__wrap_ioremap_wc(resource_size_t offset, unsigned long size)
 {
 	return __nfit_test_ioremap(offset, size, ioremap_wc);
@@ -117,6 +120,19 @@ void __wrap_iounmap(volatile void __iomem *addr)
 }
 EXPORT_SYMBOL(__wrap_iounmap);
 
+void __wrap_memunmap(void *addr)
+{
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res((unsigned long) addr);
+	rcu_read_unlock();
+	if (nfit_res)
+		return;
+	return memunmap(addr);
+}
+EXPORT_SYMBOL(__wrap_memunmap);
+
 struct resource *__wrap___request_region(struct resource *parent,
 		resource_size_t start, resource_size_t n, const char *name,
 		int flags)

