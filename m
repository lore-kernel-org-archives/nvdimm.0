Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 8/9] tools/testing/libnvdimm: cleanup mock resource lookup
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:15:10 -0800
Message-ID: <20151215021510.37090.35956.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Push the locking around get_nfit_res() into get_nfit_res().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/iomap.c |   86 +++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 47 deletions(-)

diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 802d3a173ccf..d9c6c5af67e8 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/io.h>
+#include <linux/mm.h>
 #include "nfit_test.h"
 
 static LIST_HEAD(iomap_head);
@@ -41,7 +42,7 @@ void nfit_test_teardown(void)
 }
 EXPORT_SYMBOL(nfit_test_teardown);
 
-static struct nfit_test_resource *get_nfit_res(resource_size_t resource)
+static struct nfit_test_resource *__get_nfit_res(resource_size_t resource)
 {
 	struct iomap_ops *ops;
 
@@ -51,14 +52,22 @@ static struct nfit_test_resource *get_nfit_res(resource_size_t resource)
 	return NULL;
 }
 
-void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
-		void __iomem *(*fallback_fn)(resource_size_t, unsigned long))
+static struct nfit_test_resource *get_nfit_res(resource_size_t resource)
 {
-	struct nfit_test_resource *nfit_res;
+	struct nfit_test_resource *res;
 
 	rcu_read_lock();
-	nfit_res = get_nfit_res(offset);
+	res = __get_nfit_res(resource);
 	rcu_read_unlock();
+
+	return res;
+}
+
+void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
+		void __iomem *(*fallback_fn)(resource_size_t, unsigned long))
+{
+	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
+
 	if (nfit_res)
 		return (void __iomem *) nfit_res->buf + offset
 			- nfit_res->res->start;
@@ -68,11 +77,8 @@ void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
 void __iomem *__wrap_devm_ioremap_nocache(struct device *dev,
 		resource_size_t offset, unsigned long size)
 {
-	struct nfit_test_resource *nfit_res;
+	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
-	rcu_read_lock();
-	nfit_res = get_nfit_res(offset);
-	rcu_read_unlock();
 	if (nfit_res)
 		return (void __iomem *) nfit_res->buf + offset
 			- nfit_res->res->start;
@@ -83,55 +89,55 @@ EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
 void *__wrap_devm_memremap(struct device *dev, resource_size_t offset,
 		size_t size, unsigned long flags)
 {
-	struct nfit_test_resource *nfit_res;
+	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
-	rcu_read_lock();
-	nfit_res = get_nfit_res(offset);
-	rcu_read_unlock();
 	if (nfit_res)
 		return nfit_res->buf + offset - nfit_res->res->start;
 	return devm_memremap(dev, offset, size, flags);
 }
 EXPORT_SYMBOL(__wrap_devm_memremap);
 
-void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res)
+#ifdef PFN_MAP
+void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res,
+		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
-	struct nfit_test_resource *nfit_res;
 	resource_size_t offset = res->start;
+	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
-	rcu_read_lock();
-	nfit_res = get_nfit_res(offset);
-	rcu_read_unlock();
 	if (nfit_res)
 		return nfit_res->buf + offset - nfit_res->res->start;
-	return devm_memremap_pages(dev, res);
+	return devm_memremap_pages(dev, res, ref, altmap);
 }
 EXPORT_SYMBOL(__wrap_devm_memremap_pages);
 
-#ifdef PFN_MAP
 pfn_t __wrap_phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
 {
-	struct nfit_test_resource *nfit_res;
-
-	rcu_read_lock();
-	nfit_res = get_nfit_res(offset);
-	rcu_read_unlock();
+	struct nfit_test_resource *nfit_res = get_nfit_res(addr);
 
 	if (nfit_res)
 		flags &= ~PFN_MAP;
-        return phys_to_pfn_t(addr >> PAGE_SHIFT, flags);
+        return phys_to_pfn_t(addr, flags);
 }
 EXPORT_SYMBOL(__wrap_phys_to_pfn_t);
+#else
+/* to be removed post 4.5-rc1 */
+void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res)
+{
+	resource_size_t offset = res->start;
+	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
+
+	if (nfit_res)
+		return nfit_res->buf + offset - nfit_res->res->start;
+	return devm_memremap_pages(dev, res);
+}
+EXPORT_SYMBOL(__wrap_devm_memremap_pages);
 #endif
 
 void *__wrap_memremap(resource_size_t offset, size_t size,
 		unsigned long flags)
 {
-	struct nfit_test_resource *nfit_res;
+	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
-	rcu_read_lock();
-	nfit_res = get_nfit_res(offset);
-	rcu_read_unlock();
 	if (nfit_res)
 		return nfit_res->buf + offset - nfit_res->res->start;
 	return memremap(offset, size, flags);
@@ -140,11 +146,8 @@ EXPORT_SYMBOL(__wrap_memremap);
 
 void __wrap_devm_memunmap(struct device *dev, void *addr)
 {
-	struct nfit_test_resource *nfit_res;
+	struct nfit_test_resource *nfit_res = get_nfit_res((long) addr);
 
-	rcu_read_lock();
-	nfit_res = get_nfit_res((unsigned long) addr);
-	rcu_read_unlock();
 	if (nfit_res)
 		return;
 	return devm_memunmap(dev, addr);
@@ -165,11 +168,7 @@ EXPORT_SYMBOL(__wrap_ioremap_wc);
 
 void __wrap_iounmap(volatile void __iomem *addr)
 {
-	struct nfit_test_resource *nfit_res;
-
-	rcu_read_lock();
-	nfit_res = get_nfit_res((unsigned long) addr);
-	rcu_read_unlock();
+	struct nfit_test_resource *nfit_res = get_nfit_res((long) addr);
 	if (nfit_res)
 		return;
 	return iounmap(addr);
@@ -178,11 +177,8 @@ EXPORT_SYMBOL(__wrap_iounmap);
 
 void __wrap_memunmap(void *addr)
 {
-	struct nfit_test_resource *nfit_res;
+	struct nfit_test_resource *nfit_res = get_nfit_res((long) addr);
 
-	rcu_read_lock();
-	nfit_res = get_nfit_res((unsigned long) addr);
-	rcu_read_unlock();
 	if (nfit_res)
 		return;
 	return memunmap(addr);
@@ -196,9 +192,7 @@ static struct resource *nfit_test_request_region(struct device *dev,
 	struct nfit_test_resource *nfit_res;
 
 	if (parent == &iomem_resource) {
-		rcu_read_lock();
 		nfit_res = get_nfit_res(start);
-		rcu_read_unlock();
 		if (nfit_res) {
 			struct resource *res = nfit_res->res + 1;
 
@@ -248,9 +242,7 @@ void __wrap___release_region(struct resource *parent, resource_size_t start,
 	struct nfit_test_resource *nfit_res;
 
 	if (parent == &iomem_resource) {
-		rcu_read_lock();
 		nfit_res = get_nfit_res(start);
-		rcu_read_unlock();
 		if (nfit_res) {
 			struct resource *res = nfit_res->res + 1;
 

