Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6F5621962301
 for <linux-nvdimm@lists.01.org>; Wed,  5 Dec 2018 14:28:32 -0800 (PST)
Subject: [PATCH v2] tools/testing/nvdimm: Align test resources to 128M
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Dec 2018 14:15:57 -0800
Message-ID: <154404811026.277309.7171897179868103531.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154308521932.237140.13650270234597178173.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154308521932.237140.13650270234597178173.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for libnvdimm growing new restrictions to detect section
conflicts between persistent memory regions, enable nfit_test to
allocate aligned resources. Use a gen_pool to allocate nfit_test's fake
resources in a separate address space from the virtual translation of
the same.

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes in v2:
* Fix intermittent crash from stale vmalloc() alias usage (Vishal)

 tools/testing/nvdimm/test/nfit.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 01ec04bf91b5..6c16ac36d482 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -15,6 +15,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/workqueue.h>
 #include <linux/libnvdimm.h>
+#include <linux/genalloc.h>
 #include <linux/vmalloc.h>
 #include <linux/device.h>
 #include <linux/module.h>
@@ -215,6 +216,8 @@ struct nfit_test {
 
 static struct workqueue_struct *nfit_wq;
 
+static struct gen_pool *nfit_pool;
+
 static struct nfit_test *to_nfit_test(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1132,6 +1135,9 @@ static void release_nfit_res(void *data)
 	list_del(&nfit_res->list);
 	spin_unlock(&nfit_test_lock);
 
+	if (resource_size(&nfit_res->res) >= DIMM_SIZE)
+		gen_pool_free(nfit_pool, nfit_res->res.start,
+				resource_size(&nfit_res->res));
 	vfree(nfit_res->buf);
 	kfree(nfit_res);
 }
@@ -1144,7 +1150,7 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
 			GFP_KERNEL);
 	int rc;
 
-	if (!buf || !nfit_res)
+	if (!buf || !nfit_res || !*dma)
 		goto err;
 	rc = devm_add_action(dev, release_nfit_res, nfit_res);
 	if (rc)
@@ -1164,6 +1170,8 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
 
 	return nfit_res->buf;
  err:
+	if (*dma && size >= DIMM_SIZE)
+		gen_pool_free(nfit_pool, *dma, size);
 	if (buf)
 		vfree(buf);
 	kfree(nfit_res);
@@ -1172,9 +1180,16 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
 
 static void *test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma)
 {
+	struct genpool_data_align data = {
+		.align = SZ_128M,
+	};
 	void *buf = vmalloc(size);
 
-	*dma = (unsigned long) buf;
+	if (size >= DIMM_SIZE)
+		*dma = gen_pool_alloc_algo(nfit_pool, size,
+				gen_pool_first_fit_align, &data);
+	else
+		*dma = (unsigned long) buf;
 	return __test_alloc(t, size, dma, buf);
 }
 
@@ -2839,6 +2854,17 @@ static __init int nfit_test_init(void)
 		goto err_register;
 	}
 
+	nfit_pool = gen_pool_create(ilog2(SZ_4M), NUMA_NO_NODE);
+	if (!nfit_pool) {
+		rc = -ENOMEM;
+		goto err_register;
+	}
+
+	if (gen_pool_add(nfit_pool, SZ_4G, SZ_4G, NUMA_NO_NODE)) {
+		rc = -ENOMEM;
+		goto err_register;
+	}
+
 	for (i = 0; i < NUM_NFITS; i++) {
 		struct nfit_test *nfit_test;
 		struct platform_device *pdev;
@@ -2894,6 +2920,9 @@ static __init int nfit_test_init(void)
 	return 0;
 
  err_register:
+	if (nfit_pool)
+		gen_pool_destroy(nfit_pool);
+
 	destroy_workqueue(nfit_wq);
 	for (i = 0; i < NUM_NFITS; i++)
 		if (instances[i])
@@ -2917,6 +2946,8 @@ static __exit void nfit_test_exit(void)
 	platform_driver_unregister(&nfit_test_driver);
 	nfit_test_teardown();
 
+	gen_pool_destroy(nfit_pool);
+
 	for (i = 0; i < NUM_NFITS; i++)
 		put_device(&instances[i]->pdev.dev);
 	class_destroy(nfit_test_dimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
