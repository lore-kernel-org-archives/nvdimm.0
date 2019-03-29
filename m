Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36CEB211EA9EC
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 08:40:30 -0700 (PDT)
Subject: [PATCH 5/6] pci/p2pdma: Track pgmap references per resource,
 not globally
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Mar 2019 08:27:50 -0700
Message-ID: <155387327020.2443841.6446837127378298192.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for fixing a race between devm_memremap_pages_release()
and the final put of a page from the device-page-map, allocate a
percpu-ref per p2pdma resource mapping.

Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/pci/p2pdma.c |  114 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 73 insertions(+), 41 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 595a534bd749..1b96c1688715 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -20,12 +20,16 @@
 #include <linux/seq_buf.h>
 
 struct pci_p2pdma {
-	struct percpu_ref devmap_ref;
-	struct completion devmap_ref_done;
 	struct gen_pool *pool;
 	bool p2pmem_published;
 };
 
+struct p2pdma_pagemap {
+	struct dev_pagemap pgmap;
+	struct percpu_ref ref;
+	struct completion ref_done;
+};
+
 static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
@@ -74,28 +78,31 @@ static const struct attribute_group p2pmem_group = {
 	.name = "p2pmem",
 };
 
+static struct p2pdma_pagemap *to_p2p_pgmap(struct percpu_ref *ref)
+{
+	return container_of(ref, struct p2pdma_pagemap, ref);
+}
+
 static void pci_p2pdma_percpu_release(struct percpu_ref *ref)
 {
-	struct pci_p2pdma *p2p =
-		container_of(ref, struct pci_p2pdma, devmap_ref);
+	struct p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(ref);
 
-	complete_all(&p2p->devmap_ref_done);
+	complete(&p2p_pgmap->ref_done);
 }
 
 static void pci_p2pdma_percpu_kill(struct percpu_ref *ref)
 {
-	/*
-	 * pci_p2pdma_add_resource() may be called multiple times
-	 * by a driver and may register the percpu_kill devm action multiple
-	 * times. We only want the first action to actually kill the
-	 * percpu_ref.
-	 */
-	if (percpu_ref_is_dying(ref))
-		return;
-
 	percpu_ref_kill(ref);
 }
 
+static void pci_p2pdma_percpu_cleanup(void *ref)
+{
+	struct p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(ref);
+
+	wait_for_completion(&p2p_pgmap->ref_done);
+	percpu_ref_exit(&p2p_pgmap->ref);
+}
+
 static void pci_p2pdma_release(void *data)
 {
 	struct pci_dev *pdev = data;
@@ -103,12 +110,12 @@ static void pci_p2pdma_release(void *data)
 	if (!pdev->p2pdma)
 		return;
 
-	wait_for_completion(&pdev->p2pdma->devmap_ref_done);
-	percpu_ref_exit(&pdev->p2pdma->devmap_ref);
+	/* Flush and disable pci_alloc_p2p_mem() */
+	pdev->p2pdma = NULL;
+	synchronize_rcu();
 
 	gen_pool_destroy(pdev->p2pdma->pool);
 	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
-	pdev->p2pdma = NULL;
 }
 
 static int pci_p2pdma_setup(struct pci_dev *pdev)
@@ -124,12 +131,6 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
 	if (!p2p->pool)
 		goto out;
 
-	init_completion(&p2p->devmap_ref_done);
-	error = percpu_ref_init(&p2p->devmap_ref,
-			pci_p2pdma_percpu_release, 0, GFP_KERNEL);
-	if (error)
-		goto out_pool_destroy;
-
 	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_release, pdev);
 	if (error)
 		goto out_pool_destroy;
@@ -163,6 +164,7 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			    u64 offset)
 {
+	struct p2pdma_pagemap *p2p_pgmap;
 	struct dev_pagemap *pgmap;
 	void *addr;
 	int error;
@@ -185,14 +187,32 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 			return error;
 	}
 
-	pgmap = devm_kzalloc(&pdev->dev, sizeof(*pgmap), GFP_KERNEL);
-	if (!pgmap)
+	p2p_pgmap = devm_kzalloc(&pdev->dev, sizeof(*p2p_pgmap), GFP_KERNEL);
+	if (!p2p_pgmap)
 		return -ENOMEM;
 
+	init_completion(&p2p_pgmap->ref_done);
+	error = percpu_ref_init(&p2p_pgmap->ref,
+			pci_p2pdma_percpu_release, 0, GFP_KERNEL);
+	if (error)
+		goto pgmap_free;
+
+	/*
+	 * FIXME: the percpu_ref_exit needs to be coordinated internal
+	 * to devm_memremap_pages_release(). Duplicate the same ordering
+	 * as other devm_memremap_pages() users for now.
+	 */
+	error = devm_add_action(&pdev->dev, pci_p2pdma_percpu_cleanup,
+			&p2p_pgmap->ref);
+	if (error)
+		goto ref_cleanup;
+
+	pgmap = &p2p_pgmap->pgmap;
+
 	pgmap->res.start = pci_resource_start(pdev, bar) + offset;
 	pgmap->res.end = pgmap->res.start + size - 1;
 	pgmap->res.flags = pci_resource_flags(pdev, bar);
-	pgmap->ref = &pdev->p2pdma->devmap_ref;
+	pgmap->ref = &p2p_pgmap->ref;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->pci_p2pdma_bus_offset = pci_bus_address(pdev, bar) -
 		pci_resource_start(pdev, bar);
@@ -201,12 +221,13 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
 		error = PTR_ERR(addr);
-		goto pgmap_free;
+		goto ref_exit;
 	}
 
-	error = gen_pool_add_virt(pdev->p2pdma->pool, (unsigned long)addr,
+	error = gen_pool_add_owner(pdev->p2pdma->pool, (unsigned long)addr,
 			pci_bus_address(pdev, bar) + offset,
-			resource_size(&pgmap->res), dev_to_node(&pdev->dev));
+			resource_size(&pgmap->res), dev_to_node(&pdev->dev),
+			&p2p_pgmap->ref);
 	if (error)
 		goto pages_free;
 
@@ -217,8 +238,10 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 
 pages_free:
 	devm_memunmap_pages(&pdev->dev, pgmap);
+ref_cleanup:
+	percpu_ref_exit(&p2p_pgmap->ref);
 pgmap_free:
-	devm_kfree(&pdev->dev, pgmap);
+	devm_kfree(&pdev->dev, p2p_pgmap);
 	return error;
 }
 EXPORT_SYMBOL_GPL(pci_p2pdma_add_resource);
@@ -555,19 +578,25 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_find_many);
  */
 void *pci_alloc_p2pmem(struct pci_dev *pdev, size_t size)
 {
-	void *ret;
+	void *ret = NULL;
+	struct percpu_ref *ref;
 
+	rcu_read_lock();
 	if (unlikely(!pdev->p2pdma))
-		return NULL;
-
-	if (unlikely(!percpu_ref_tryget_live(&pdev->p2pdma->devmap_ref)))
-		return NULL;
-
-	ret = (void *)gen_pool_alloc(pdev->p2pdma->pool, size);
+		goto out;
 
-	if (unlikely(!ret))
-		percpu_ref_put(&pdev->p2pdma->devmap_ref);
+	ret = (void *)gen_pool_alloc_owner(pdev->p2pdma->pool, size,
+			(void **) &ref);
+	if (!ret)
+		goto out;
 
+	if (unlikely(!percpu_ref_tryget_live(ref))) {
+		gen_pool_free(pdev->p2pdma->pool, (unsigned long) ret, size);
+		ret = NULL;
+		goto out;
+	}
+out:
+	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pci_alloc_p2pmem);
@@ -580,8 +609,11 @@ EXPORT_SYMBOL_GPL(pci_alloc_p2pmem);
  */
 void pci_free_p2pmem(struct pci_dev *pdev, void *addr, size_t size)
 {
-	gen_pool_free(pdev->p2pdma->pool, (uintptr_t)addr, size);
-	percpu_ref_put(&pdev->p2pdma->devmap_ref);
+	struct percpu_ref *ref;
+
+	gen_pool_free_owner(pdev->p2pdma->pool, (uintptr_t)addr, size,
+			(void **) &ref);
+	percpu_ref_put(ref);
 }
 EXPORT_SYMBOL_GPL(pci_free_p2pmem);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
