Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CFD9E1A1E4F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:10 -0700 (PDT)
Subject: [PATCH 05/14] tools/testing/nvdimm: support for sub-dividing a pmem
 region
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:08 -0700
Message-ID: <147585834790.22349.5107233158248726938.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Update nfit_test to handle multiple sub-allocations within a given pmem
region.  The mock resource now tracks and un-tracks sub-ranges as they
are requested and released (either explicitly or via devm callback).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/iomap.c     |  134 ++++++++++++++++++++++++++-------
 tools/testing/nvdimm/test/nfit.c      |   21 ++---
 tools/testing/nvdimm/test/nfit_test.h |   12 +++
 3 files changed, 124 insertions(+), 43 deletions(-)

diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index dae5b9b6d186..3ccef732fce9 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -74,7 +74,7 @@ void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
 
 	if (nfit_res)
 		return (void __iomem *) nfit_res->buf + offset
-			- nfit_res->res->start;
+			- nfit_res->res.start;
 	return fallback_fn(offset, size);
 }
 
@@ -85,7 +85,7 @@ void __iomem *__wrap_devm_ioremap_nocache(struct device *dev,
 
 	if (nfit_res)
 		return (void __iomem *) nfit_res->buf + offset
-			- nfit_res->res->start;
+			- nfit_res->res.start;
 	return devm_ioremap_nocache(dev, offset, size);
 }
 EXPORT_SYMBOL(__wrap_devm_ioremap_nocache);
@@ -96,7 +96,7 @@ void *__wrap_devm_memremap(struct device *dev, resource_size_t offset,
 	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
 	if (nfit_res)
-		return nfit_res->buf + offset - nfit_res->res->start;
+		return nfit_res->buf + offset - nfit_res->res.start;
 	return devm_memremap(dev, offset, size, flags);
 }
 EXPORT_SYMBOL(__wrap_devm_memremap);
@@ -108,7 +108,7 @@ void *__wrap_devm_memremap_pages(struct device *dev, struct resource *res,
 	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
 	if (nfit_res)
-		return nfit_res->buf + offset - nfit_res->res->start;
+		return nfit_res->buf + offset - nfit_res->res.start;
 	return devm_memremap_pages(dev, res, ref, altmap);
 }
 EXPORT_SYMBOL(__wrap_devm_memremap_pages);
@@ -129,7 +129,7 @@ void *__wrap_memremap(resource_size_t offset, size_t size,
 	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
 	if (nfit_res)
-		return nfit_res->buf + offset - nfit_res->res->start;
+		return nfit_res->buf + offset - nfit_res->res.start;
 	return memremap(offset, size, flags);
 }
 EXPORT_SYMBOL(__wrap_memremap);
@@ -175,6 +175,63 @@ void __wrap_memunmap(void *addr)
 }
 EXPORT_SYMBOL(__wrap_memunmap);
 
+static bool nfit_test_release_region(struct device *dev,
+		struct resource *parent, resource_size_t start,
+		resource_size_t n);
+
+static void nfit_devres_release(struct device *dev, void *data)
+{
+	struct resource *res = *((struct resource **) data);
+
+	WARN_ON(!nfit_test_release_region(NULL, &iomem_resource, res->start,
+			resource_size(res)));
+}
+
+static int match(struct device *dev, void *__res, void *match_data)
+{
+	struct resource *res = *((struct resource **) __res);
+	resource_size_t start = *((resource_size_t *) match_data);
+
+	return res->start == start;
+}
+
+static bool nfit_test_release_region(struct device *dev,
+		struct resource *parent, resource_size_t start,
+		resource_size_t n)
+{
+	if (parent == &iomem_resource) {
+		struct nfit_test_resource *nfit_res = get_nfit_res(start);
+
+		if (nfit_res) {
+			struct nfit_test_request *req;
+			struct resource *res = NULL;
+
+			if (dev) {
+				devres_release(dev, nfit_devres_release, match,
+						&start);
+				return true;
+			}
+
+			spin_lock(&nfit_res->lock);
+			list_for_each_entry(req, &nfit_res->requests, list)
+				if (req->res.start == start) {
+					res = &req->res;
+					list_del(&req->list);
+					break;
+				}
+			spin_unlock(&nfit_res->lock);
+
+			WARN(!res || resource_size(res) != n,
+					"%s: start: %llx n: %llx mismatch: %pr\n",
+						__func__, start, n, res);
+			if (res)
+				kfree(req);
+			return true;
+		}
+	}
+	return false;
+}
+
 static struct resource *nfit_test_request_region(struct device *dev,
 		struct resource *parent, resource_size_t start,
 		resource_size_t n, const char *name, int flags)
@@ -184,21 +241,57 @@ static struct resource *nfit_test_request_region(struct device *dev,
 	if (parent == &iomem_resource) {
 		nfit_res = get_nfit_res(start);
 		if (nfit_res) {
-			struct resource *res = nfit_res->res + 1;
+			struct nfit_test_request *req;
+			struct resource *res = NULL;
 
-			if (start + n > nfit_res->res->start
-					+ resource_size(nfit_res->res)) {
+			if (start + n > nfit_res->res.start
+					+ resource_size(&nfit_res->res)) {
 				pr_debug("%s: start: %llx n: %llx overflow: %pr\n",
 						__func__, start, n,
-						nfit_res->res);
+						&nfit_res->res);
+				return NULL;
+			}
+
+			spin_lock(&nfit_res->lock);
+			list_for_each_entry(req, &nfit_res->requests, list)
+				if (start == req->res.start) {
+					res = &req->res;
+					break;
+				}
+			spin_unlock(&nfit_res->lock);
+
+			if (res) {
+				WARN(1, "%pr already busy\n", res);
 				return NULL;
 			}
 
+			req = kzalloc(sizeof(*req), GFP_KERNEL);
+			if (!req)
+				return NULL;
+			INIT_LIST_HEAD(&req->list);
+			res = &req->res;
+
 			res->start = start;
 			res->end = start + n - 1;
 			res->name = name;
 			res->flags = resource_type(parent);
 			res->flags |= IORESOURCE_BUSY | flags;
+			spin_lock(&nfit_res->lock);
+			list_add(&req->list, &nfit_res->requests);
+			spin_unlock(&nfit_res->lock);
+
+			if (dev) {
+				struct resource **d;
+
+				d = devres_alloc(nfit_devres_release,
+						sizeof(struct resource *),
+						GFP_KERNEL);
+				if (!d)
+					return NULL;
+				*d = res;
+				devres_add(dev, d);
+			}
+
 			pr_debug("%s: %pr\n", __func__, res);
 			return res;
 		}
@@ -242,29 +335,10 @@ struct resource *__wrap___devm_request_region(struct device *dev,
 }
 EXPORT_SYMBOL(__wrap___devm_request_region);
 
-static bool nfit_test_release_region(struct resource *parent,
-		resource_size_t start, resource_size_t n)
-{
-	if (parent == &iomem_resource) {
-		struct nfit_test_resource *nfit_res = get_nfit_res(start);
-		if (nfit_res) {
-			struct resource *res = nfit_res->res + 1;
-
-			if (start != res->start || resource_size(res) != n)
-				pr_info("%s: start: %llx n: %llx mismatch: %pr\n",
-						__func__, start, n, res);
-			else
-				memset(res, 0, sizeof(*res));
-			return true;
-		}
-	}
-	return false;
-}
-
 void __wrap___release_region(struct resource *parent, resource_size_t start,
 		resource_size_t n)
 {
-	if (!nfit_test_release_region(parent, start, n))
+	if (!nfit_test_release_region(NULL, parent, start, n))
 		__release_region(parent, start, n);
 }
 EXPORT_SYMBOL(__wrap___release_region);
@@ -272,7 +346,7 @@ EXPORT_SYMBOL(__wrap___release_region);
 void __wrap___devm_release_region(struct device *dev, struct resource *parent,
 		resource_size_t start, resource_size_t n)
 {
-	if (!nfit_test_release_region(parent, start, n))
+	if (!nfit_test_release_region(dev, parent, start, n))
 		__devm_release_region(dev, parent, start, n);
 }
 EXPORT_SYMBOL(__wrap___devm_release_region);
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 175fc24f8f3a..0e721c6fb1cf 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -478,14 +478,12 @@ static struct nfit_test *instances[NUM_NFITS];
 static void release_nfit_res(void *data)
 {
 	struct nfit_test_resource *nfit_res = data;
-	struct resource *res = nfit_res->res;
 
 	spin_lock(&nfit_test_lock);
 	list_del(&nfit_res->list);
 	spin_unlock(&nfit_test_lock);
 
 	vfree(nfit_res->buf);
-	kfree(res);
 	kfree(nfit_res);
 }
 
@@ -493,12 +491,11 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
 		void *buf)
 {
 	struct device *dev = &t->pdev.dev;
-	struct resource *res = kzalloc(sizeof(*res) * 2, GFP_KERNEL);
 	struct nfit_test_resource *nfit_res = kzalloc(sizeof(*nfit_res),
 			GFP_KERNEL);
 	int rc;
 
-	if (!res || !buf || !nfit_res)
+	if (!buf || !nfit_res)
 		goto err;
 	rc = devm_add_action(dev, release_nfit_res, nfit_res);
 	if (rc)
@@ -507,10 +504,11 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
 	memset(buf, 0, size);
 	nfit_res->dev = dev;
 	nfit_res->buf = buf;
-	nfit_res->res = res;
-	res->start = *dma;
-	res->end = *dma + size - 1;
-	res->name = "NFIT";
+	nfit_res->res.start = *dma;
+	nfit_res->res.end = *dma + size - 1;
+	nfit_res->res.name = "NFIT";
+	spin_lock_init(&nfit_res->lock);
+	INIT_LIST_HEAD(&nfit_res->requests);
 	spin_lock(&nfit_test_lock);
 	list_add(&nfit_res->list, &t->resources);
 	spin_unlock(&nfit_test_lock);
@@ -519,7 +517,6 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
  err:
 	if (buf)
 		vfree(buf);
-	kfree(res);
 	kfree(nfit_res);
 	return NULL;
 }
@@ -544,13 +541,13 @@ static struct nfit_test_resource *nfit_test_lookup(resource_size_t addr)
 			continue;
 		spin_lock(&nfit_test_lock);
 		list_for_each_entry(n, &t->resources, list) {
-			if (addr >= n->res->start && (addr < n->res->start
-						+ resource_size(n->res))) {
+			if (addr >= n->res.start && (addr < n->res.start
+						+ resource_size(&n->res))) {
 				nfit_res = n;
 				break;
 			} else if (addr >= (unsigned long) n->buf
 					&& (addr < (unsigned long) n->buf
-						+ resource_size(n->res))) {
+						+ resource_size(&n->res))) {
 				nfit_res = n;
 				break;
 			}
diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index 9f18e2a4a862..c281dd2e5e2d 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -13,11 +13,21 @@
 #ifndef __NFIT_TEST_H__
 #define __NFIT_TEST_H__
 #include <linux/list.h>
+#include <linux/ioport.h>
+#include <linux/spinlock_types.h>
+
+struct nfit_test_request {
+	struct list_head list;
+	struct resource res;
+};
 
 struct nfit_test_resource {
+	struct list_head requests;
 	struct list_head list;
-	struct resource *res;
+	struct resource res;
 	struct device *dev;
+	spinlock_t lock;
+	int req_count;
 	void *buf;
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
