Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15B1C21F2E0E2
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 02:09:01 -0700 (PDT)
Date: Mon, 9 Apr 2018 17:08:53 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link resource sibling
Message-ID: <20180409090853.GJ19345@localhost.localdomain>
References: <20180408024724.16812-1-bhe@redhat.com>
 <20180408024724.16812-2-bhe@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180408024724.16812-2-bhe@redhat.com>
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
Cc: Brijesh Singh <brijesh.singh@amd.com>, devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, devel@linuxdriverproject.org
List-ID: <linux-nvdimm@lists.01.org>

The struct resource uses singly linked list to link siblings. It's not
easy to do reverse iteration on sibling list. So replace it with list_head.

And code refactoring makes codes in kernel/resource.c more readable than
pointer operation.

Besides, type of member variables of struct resource, sibling and child, are
changed from 'struct resource *' to 'struct list_head'. Kernel size will
increase because of those statically defined struct resource instances.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
v2->v3:
  Make sibling() and first_child() global so that they can be called
  out of kernel/resource.c to simplify code.

  Fix several code bugs found by kbuild test robot.

  Got report from lkp that kernel size increased. It's on purpose since
  the type change of sibling and child inside struct resource{}. For
  each struct resource variable, it will cost another 16 bytes on x86 64.

 arch/sparc/kernel/ioport.c                  |   2 +-
 drivers/gpu/drm/drm_memory.c                |   3 +-
 drivers/gpu/drm/gma500/gtt.c                |   5 +-
 drivers/hv/vmbus_drv.c                      |  52 ++++----
 drivers/input/joystick/iforce/iforce-main.c |   4 +-
 drivers/nvdimm/e820.c                       |   2 +-
 drivers/nvdimm/namespace_devs.c             |   6 +-
 drivers/nvdimm/nd.h                         |   5 +-
 drivers/of/address.c                        |   4 +-
 drivers/parisc/lba_pci.c                    |   4 +-
 drivers/pci/host/vmd.c                      |   8 +-
 drivers/pci/probe.c                         |   2 +
 drivers/pci/setup-bus.c                     |   2 +-
 include/linux/ioport.h                      |   6 +-
 kernel/resource.c                           | 193 ++++++++++++++--------------
 15 files changed, 149 insertions(+), 149 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 3bcef9ce74df..4e91fbbbedcc 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -669,7 +669,7 @@ static int sparc_io_proc_show(struct seq_file *m, void *v)
 	struct resource *root = m->private, *r;
 	const char *nm;
 
-	for (r = root->child; r != NULL; r = r->sibling) {
+	list_for_each_entry(r, &root->child, sibling) {
 		if ((nm = r->name) == NULL) nm = "???";
 		seq_printf(m, "%016llx-%016llx: %s\n",
 				(unsigned long long)r->start,
diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
index 3c54044214db..53e300a993dc 100644
--- a/drivers/gpu/drm/drm_memory.c
+++ b/drivers/gpu/drm/drm_memory.c
@@ -155,9 +155,8 @@ u64 drm_get_max_iomem(void)
 	struct resource *tmp;
 	resource_size_t max_iomem = 0;
 
-	for (tmp = iomem_resource.child; tmp; tmp = tmp->sibling) {
+	list_for_each_entry(tmp, &iomem_resource.child, sibling)
 		max_iomem = max(max_iomem,  tmp->end);
-	}
 
 	return max_iomem;
 }
diff --git a/drivers/gpu/drm/gma500/gtt.c b/drivers/gpu/drm/gma500/gtt.c
index 3949b0990916..addd3bc009af 100644
--- a/drivers/gpu/drm/gma500/gtt.c
+++ b/drivers/gpu/drm/gma500/gtt.c
@@ -565,7 +565,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 int psb_gtt_restore(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct resource *r = dev_priv->gtt_mem->child;
+	struct resource *r;
 	struct gtt_range *range;
 	unsigned int restored = 0, total = 0, size = 0;
 
@@ -573,14 +573,13 @@ int psb_gtt_restore(struct drm_device *dev)
 	mutex_lock(&dev_priv->gtt_mutex);
 	psb_gtt_init(dev, 1);
 
-	while (r != NULL) {
+	list_for_each_entry(r, &dev_priv->gtt_mem->child, sibling) {
 		range = container_of(r, struct gtt_range, resource);
 		if (range->pages) {
 			psb_gtt_insert(dev, range, 1);
 			size += range->resource.end - range->resource.start;
 			restored++;
 		}
-		r = r->sibling;
 		total++;
 	}
 	mutex_unlock(&dev_priv->gtt_mutex);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index bc65c4d79c1f..7ba8a25520d9 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1413,9 +1413,8 @@ static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
 {
 	resource_size_t start = 0;
 	resource_size_t end = 0;
-	struct resource *new_res;
+	struct resource *new_res, *tmp;
 	struct resource **old_res = &hyperv_mmio;
-	struct resource **prev_res = NULL;
 
 	switch (res->type) {
 
@@ -1462,44 +1461,36 @@ static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
 	/*
 	 * If two ranges are adjacent, merge them.
 	 */
-	do {
-		if (!*old_res) {
-			*old_res = new_res;
-			break;
-		}
-
-		if (((*old_res)->end + 1) == new_res->start) {
-			(*old_res)->end = new_res->end;
+	if (!*old_res) {
+		*old_res = new_res;
+		return AE_OK;
+	}
+	tmp = *old_res;
+	list_for_each_entry_from(tmp, &tmp->parent->child, sibling) {
+		if ((tmp->end + 1) == new_res->start) {
+			tmp->end = new_res->end;
 			kfree(new_res);
 			break;
 		}
 
-		if ((*old_res)->start == new_res->end + 1) {
-			(*old_res)->start = new_res->start;
+		if (tmp->start == new_res->end + 1) {
+			tmp->start = new_res->start;
 			kfree(new_res);
 			break;
 		}
 
-		if ((*old_res)->start > new_res->end) {
-			new_res->sibling = *old_res;
-			if (prev_res)
-				(*prev_res)->sibling = new_res;
-			*old_res = new_res;
+		if (tmp->start > new_res->end) {
+			list_add(&new_res->sibling, tmp->sibling.prev);
 			break;
 		}
-
-		prev_res = old_res;
-		old_res = &(*old_res)->sibling;
-
-	} while (1);
+	}
 
 	return AE_OK;
 }
 
 static int vmbus_acpi_remove(struct acpi_device *device)
 {
-	struct resource *cur_res;
-	struct resource *next_res;
+	struct resource *res;
 
 	if (hyperv_mmio) {
 		if (fb_mmio) {
@@ -1508,10 +1499,9 @@ static int vmbus_acpi_remove(struct acpi_device *device)
 			fb_mmio = NULL;
 		}
 
-		for (cur_res = hyperv_mmio; cur_res; cur_res = next_res) {
-			next_res = cur_res->sibling;
-			kfree(cur_res);
-		}
+		res = hyperv_mmio;
+		list_for_each_entry_from(res, &res->parent->child, sibling)
+			kfree(res);
 	}
 
 	return 0;
@@ -1597,7 +1587,8 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 		}
 	}
 
-	for (iter = hyperv_mmio; iter; iter = iter->sibling) {
+	iter = hyperv_mmio;
+	list_for_each_entry_from(iter, &iter->parent->child, sibling) {
 		if ((iter->start >= max) || (iter->end <= min))
 			continue;
 
@@ -1640,7 +1631,8 @@ void vmbus_free_mmio(resource_size_t start, resource_size_t size)
 	struct resource *iter;
 
 	down(&hyperv_mmio_lock);
-	for (iter = hyperv_mmio; iter; iter = iter->sibling) {
+	iter = hyperv_mmio;
+	list_for_each_entry_from(iter, &iter->parent->child, sibling) {
 		if ((iter->start >= start + size) || (iter->end <= start))
 			continue;
 
diff --git a/drivers/input/joystick/iforce/iforce-main.c b/drivers/input/joystick/iforce/iforce-main.c
index daeeb4c7e3b0..5c0be27b33ff 100644
--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -305,8 +305,8 @@ int iforce_init_device(struct iforce *iforce)
 	iforce->device_memory.end = 200;
 	iforce->device_memory.flags = IORESOURCE_MEM;
 	iforce->device_memory.parent = NULL;
-	iforce->device_memory.child = NULL;
-	iforce->device_memory.sibling = NULL;
+	INIT_LIST_HEAD(&iforce->device_memory.child);
+	INIT_LIST_HEAD(&iforce->device_memory.sibling);
 
 /*
  * Wait until device ready - until it sends its first response.
diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 6f9a6ffd7cde..513e661bb0d8 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -53,7 +53,7 @@ static int e820_pmem_probe(struct platform_device *pdev)
 		goto err;
 	platform_set_drvdata(pdev, nvdimm_bus);
 
-	for (p = iomem_resource.child; p ; p = p->sibling) {
+	list_for_each_entry(p, &iomem_resource.child, sibling) {
 		struct nd_region_desc ndr_desc;
 
 		if (p->desc != IORES_DESC_PERSISTENT_MEMORY_LEGACY)
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 658ada497be0..bcbdf5335909 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -637,7 +637,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
  retry:
 	first = 0;
 	for_each_dpa_resource(ndd, res) {
-		struct resource *next = res->sibling, *new_res = NULL;
+		struct resource *next = sibling(res), *new_res = NULL;
 		resource_size_t allocate, available = 0;
 		enum alloc_loc loc = ALLOC_ERR;
 		const char *action;
@@ -763,7 +763,7 @@ static resource_size_t scan_allocate(struct nd_region *nd_region,
 	 * an initial "pmem-reserve pass".  Only do an initial BLK allocation
 	 * when none of the DPA space is reserved.
 	 */
-	if ((is_pmem || !ndd->dpa.child) && n == to_allocate)
+	if ((is_pmem || list_empty(&ndd->dpa.child)) && n == to_allocate)
 		return init_dpa_allocation(label_id, nd_region, nd_mapping, n);
 	return n;
 }
@@ -779,7 +779,7 @@ static int merge_dpa(struct nd_region *nd_region,
  retry:
 	for_each_dpa_resource(ndd, res) {
 		int rc;
-		struct resource *next = res->sibling;
+		struct resource *next = sibling(res);
 		resource_size_t end = res->start + resource_size(res);
 
 		if (!next || strcmp(res->name, label_id->id) != 0
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 184e070d50a2..1dc0b2370bd1 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -102,11 +102,10 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 		(unsigned long long) (res ? res->start : 0), ##arg)
 
 #define for_each_dpa_resource(ndd, res) \
-	for (res = (ndd)->dpa.child; res; res = res->sibling)
+	list_for_each_entry(res, &(ndd)->dpa.child, sibling)
 
 #define for_each_dpa_resource_safe(ndd, res, next) \
-	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
-			res; res = next, next = next ? next->sibling : NULL)
+	list_for_each_entry_safe(res, next, &(ndd)->dpa.child, sibling)
 
 struct nd_percpu_lane {
 	int count;
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 53349912ac75..e2e25719ab52 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -330,7 +330,9 @@ int of_pci_range_to_resource(struct of_pci_range *range,
 {
 	int err;
 	res->flags = range->flags;
-	res->parent = res->child = res->sibling = NULL;
+	res->parent = NULL;
+	INIT_LIST_HEAD(&res->child);
+	INIT_LIST_HEAD(&res->sibling);
 	res->name = np->full_name;
 
 	if (res->flags & IORESOURCE_IO) {
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 69bd98421eb1..84f04418ae0b 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -170,8 +170,8 @@ lba_dump_res(struct resource *r, int d)
 	for (i = d; i ; --i) printk(" ");
 	printk(KERN_DEBUG "%p [%lx,%lx]/%lx\n", r,
 		(long)r->start, (long)r->end, r->flags);
-	lba_dump_res(r->child, d+2);
-	lba_dump_res(r->sibling, d);
+	lba_dump_res(first_child(&r->child), d+2);
+	lba_dump_res(sibling(r), d);
 }
 
 
diff --git a/drivers/pci/host/vmd.c b/drivers/pci/host/vmd.c
index 930a8fa08bd6..c3000af903ea 100644
--- a/drivers/pci/host/vmd.c
+++ b/drivers/pci/host/vmd.c
@@ -520,14 +520,14 @@ static struct pci_ops vmd_ops = {
 
 static void vmd_attach_resources(struct vmd_dev *vmd)
 {
-	vmd->dev->resource[VMD_MEMBAR1].child = &vmd->resources[1];
-	vmd->dev->resource[VMD_MEMBAR2].child = &vmd->resources[2];
+	list_add(&vmd->resources[1].sibling, &vmd->dev->resource[VMD_MEMBAR1].child);
+	list_add(&vmd->resources[2].sibling, &vmd->dev->resource[VMD_MEMBAR2].child);
 }
 
 static void vmd_detach_resources(struct vmd_dev *vmd)
 {
-	vmd->dev->resource[VMD_MEMBAR1].child = NULL;
-	vmd->dev->resource[VMD_MEMBAR2].child = NULL;
+	INIT_LIST_HEAD(&vmd->dev->resource[VMD_MEMBAR1].child);
+	INIT_LIST_HEAD(&vmd->dev->resource[VMD_MEMBAR2].child);
 }
 
 /*
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ac91b6fd0bcd..d162c77bec29 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -59,6 +59,8 @@ static struct resource *get_pci_domain_busn_res(int domain_nr)
 	r->res.start = 0;
 	r->res.end = 0xff;
 	r->res.flags = IORESOURCE_BUS | IORESOURCE_PCI_FIXED;
+	INIT_LIST_HEAD(&r->res.child);
+	INIT_LIST_HEAD(&r->res.sibling);
 
 	list_add_tail(&r->list, &pci_domain_busn_res_list);
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 072784f55ea5..0d5e30004ca6 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2107,7 +2107,7 @@ int pci_reassign_bridge_resources(struct pci_dev *bridge, unsigned long type)
 				continue;
 
 			/* Ignore BARs which are still in use */
-			if (res->child)
+			if (!list_empty(&res->child))
 				continue;
 
 			ret = add_to_list(&saved, bridge, res, 0, 0);
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index da0ebaec25f0..03d1510f03e0 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -22,7 +22,8 @@ struct resource {
 	const char *name;
 	unsigned long flags;
 	unsigned long desc;
-	struct resource *parent, *sibling, *child;
+	struct list_head child, sibling;
+	struct resource *parent;
 };
 
 /*
@@ -189,6 +190,8 @@ extern int allocate_resource(struct resource *root, struct resource *new,
 						       resource_size_t,
 						       resource_size_t),
 			     void *alignf_data);
+extern struct resource *sibling(struct resource *res);
+extern struct resource *first_child(struct list_head *head);
 struct resource *lookup_resource(struct resource *root, resource_size_t start);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
@@ -215,7 +218,6 @@ static inline bool resource_contains(struct resource *r1, struct resource *r2)
 	return r1->start <= r2->start && r1->end >= r2->end;
 }
 
-
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)		__request_region(&ioport_resource, (start), (n), (name), 0)
 #define request_muxed_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), IORESOURCE_MUXED)
diff --git a/kernel/resource.c b/kernel/resource.c
index e270b5048988..473c624606f9 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -31,6 +31,8 @@ struct resource ioport_resource = {
 	.start	= 0,
 	.end	= IO_SPACE_LIMIT,
 	.flags	= IORESOURCE_IO,
+	.sibling = LIST_HEAD_INIT(ioport_resource.sibling),
+	.child  = LIST_HEAD_INIT(ioport_resource.child),
 };
 EXPORT_SYMBOL(ioport_resource);
 
@@ -39,6 +41,8 @@ struct resource iomem_resource = {
 	.start	= 0,
 	.end	= -1,
 	.flags	= IORESOURCE_MEM,
+	.sibling = LIST_HEAD_INIT(iomem_resource.sibling),
+	.child  = LIST_HEAD_INIT(iomem_resource.child),
 };
 EXPORT_SYMBOL(iomem_resource);
 
@@ -57,20 +61,32 @@ static DEFINE_RWLOCK(resource_lock);
  * by boot mem after the system is up. So for reusing the resource entry
  * we need to remember the resource.
  */
-static struct resource *bootmem_resource_free;
+static struct list_head bootmem_resource_free = LIST_HEAD_INIT(bootmem_resource_free);
 static DEFINE_SPINLOCK(bootmem_resource_lock);
 
+struct resource *sibling(struct resource *res)
+{
+	if (res->parent && !list_is_last(&res->sibling, &res->parent->child))
+		return list_next_entry(res, sibling);
+	return NULL;
+}
+
+struct resource *first_child(struct list_head *head)
+{
+	return list_first_entry_or_null(head, struct resource, sibling);
+}
+
 static struct resource *next_resource(struct resource *p, bool sibling_only)
 {
 	/* Caller wants to traverse through siblings only */
 	if (sibling_only)
-		return p->sibling;
+		return sibling(p);
 
-	if (p->child)
-		return p->child;
-	while (!p->sibling && p->parent)
+	if (!list_empty(&p->child))
+		return first_child(&p->child);
+	while (!sibling(p) && p->parent)
 		p = p->parent;
-	return p->sibling;
+	return sibling(p);
 }
 
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
@@ -90,7 +106,7 @@ static void *r_start(struct seq_file *m, loff_t *pos)
 	struct resource *p = m->private;
 	loff_t l = 0;
 	read_lock(&resource_lock);
-	for (p = p->child; p && l < *pos; p = r_next(m, p, &l))
+	for (p = first_child(&p->child); p && l < *pos; p = r_next(m, p, &l))
 		;
 	return p;
 }
@@ -186,8 +202,7 @@ static void free_resource(struct resource *res)
 
 	if (!PageSlab(virt_to_head_page(res))) {
 		spin_lock(&bootmem_resource_lock);
-		res->sibling = bootmem_resource_free;
-		bootmem_resource_free = res;
+		list_add(&res->sibling, &bootmem_resource_free);
 		spin_unlock(&bootmem_resource_lock);
 	} else {
 		kfree(res);
@@ -199,10 +214,9 @@ static struct resource *alloc_resource(gfp_t flags)
 	struct resource *res = NULL;
 
 	spin_lock(&bootmem_resource_lock);
-	if (bootmem_resource_free) {
-		res = bootmem_resource_free;
-		bootmem_resource_free = res->sibling;
-	}
+	res = first_child(&bootmem_resource_free);
+	if (res)
+		list_del(&res->sibling);
 	spin_unlock(&bootmem_resource_lock);
 
 	if (res)
@@ -210,6 +224,8 @@ static struct resource *alloc_resource(gfp_t flags)
 	else
 		res = kzalloc(sizeof(struct resource), flags);
 
+	INIT_LIST_HEAD(&res->child);
+	INIT_LIST_HEAD(&res->sibling);
 	return res;
 }
 
@@ -218,7 +234,7 @@ static struct resource * __request_resource(struct resource *root, struct resour
 {
 	resource_size_t start = new->start;
 	resource_size_t end = new->end;
-	struct resource *tmp, **p;
+	struct resource *tmp;
 
 	if (end < start)
 		return root;
@@ -226,64 +242,62 @@ static struct resource * __request_resource(struct resource *root, struct resour
 		return root;
 	if (end > root->end)
 		return root;
-	p = &root->child;
-	for (;;) {
-		tmp = *p;
-		if (!tmp || tmp->start > end) {
-			new->sibling = tmp;
-			*p = new;
+
+	if (list_empty(&root->child)) {
+		list_add(&new->sibling, &root->child);
+		new->parent = root;
+		INIT_LIST_HEAD(&new->child);
+		return NULL;
+	}
+
+	list_for_each_entry(tmp, &root->child, sibling) {
+		if (tmp->start > end) {
+			list_add(&new->sibling, tmp->sibling.prev);
 			new->parent = root;
+			INIT_LIST_HEAD(&new->child);
 			return NULL;
 		}
-		p = &tmp->sibling;
 		if (tmp->end < start)
 			continue;
 		return tmp;
 	}
+
+	list_add_tail(&new->sibling, &root->child);
+	new->parent = root;
+	INIT_LIST_HEAD(&new->child);
+	return NULL;
 }
 
 static int __release_resource(struct resource *old, bool release_child)
 {
-	struct resource *tmp, **p, *chd;
+	struct resource *tmp, *next, *chd;
 
-	p = &old->parent->child;
-	for (;;) {
-		tmp = *p;
-		if (!tmp)
-			break;
+	list_for_each_entry_safe(tmp, next, &old->parent->child, sibling) {
 		if (tmp == old) {
-			if (release_child || !(tmp->child)) {
-				*p = tmp->sibling;
+			if (release_child || list_empty(&tmp->child)) {
+				list_del(&tmp->sibling);
 			} else {
-				for (chd = tmp->child;; chd = chd->sibling) {
+				list_for_each_entry(chd, &tmp->child, sibling)
 					chd->parent = tmp->parent;
-					if (!(chd->sibling))
-						break;
-				}
-				*p = tmp->child;
-				chd->sibling = tmp->sibling;
+				list_splice(&tmp->child, tmp->sibling.prev);
+				list_del(&tmp->sibling);
 			}
+
 			old->parent = NULL;
 			return 0;
 		}
-		p = &tmp->sibling;
 	}
 	return -EINVAL;
 }
 
 static void __release_child_resources(struct resource *r)
 {
-	struct resource *tmp, *p;
+	struct resource *tmp, *next;
 	resource_size_t size;
 
-	p = r->child;
-	r->child = NULL;
-	while (p) {
-		tmp = p;
-		p = p->sibling;
-
+	list_for_each_entry_safe(tmp, next, &r->child, sibling) {
 		tmp->parent = NULL;
-		tmp->sibling = NULL;
+		INIT_LIST_HEAD(&tmp->sibling);
 		__release_child_resources(tmp);
 
 		printk(KERN_DEBUG "release child resource %pR\n", tmp);
@@ -292,6 +306,8 @@ static void __release_child_resources(struct resource *r)
 		tmp->start = 0;
 		tmp->end = size - 1;
 	}
+
+	INIT_LIST_HEAD(&tmp->child);
 }
 
 void release_child_resources(struct resource *r)
@@ -376,7 +392,8 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
 
 	read_lock(&resource_lock);
 
-	for (p = iomem_resource.child; p; p = next_resource(p, sibling_only)) {
+	for (p = first_child(&iomem_resource.child); p;
+			p = next_resource(p, sibling_only)) {
 		if ((p->flags & res->flags) != res->flags)
 			continue;
 		if ((desc != IORES_DESC_NONE) && (desc != p->desc))
@@ -564,7 +581,7 @@ int region_intersects(resource_size_t start, size_t size, unsigned long flags,
 	struct resource *p;
 
 	read_lock(&resource_lock);
-	for (p = iomem_resource.child; p ; p = p->sibling) {
+	list_for_each_entry(p, &iomem_resource.child, sibling) {
 		bool is_type = (((p->flags & flags) == flags) &&
 				((desc == IORES_DESC_NONE) ||
 				 (desc == p->desc)));
@@ -618,7 +635,7 @@ static int __find_resource(struct resource *root, struct resource *old,
 			 resource_size_t  size,
 			 struct resource_constraint *constraint)
 {
-	struct resource *this = root->child;
+	struct resource *this = first_child(&root->child);
 	struct resource tmp = *new, avail, alloc;
 
 	tmp.start = root->start;
@@ -628,7 +645,7 @@ static int __find_resource(struct resource *root, struct resource *old,
 	 */
 	if (this && this->start == root->start) {
 		tmp.start = (this == old) ? old->start : this->end + 1;
-		this = this->sibling;
+		this = sibling(this);
 	}
 	for(;;) {
 		if (this)
@@ -663,7 +680,7 @@ next:		if (!this || this->end == root->end)
 
 		if (this != old)
 			tmp.start = this->end + 1;
-		this = this->sibling;
+		this = sibling(this);
 	}
 	return -EBUSY;
 }
@@ -707,7 +724,7 @@ static int reallocate_resource(struct resource *root, struct resource *old,
 		goto out;
 	}
 
-	if (old->child) {
+	if (!list_empty(&old->child)) {
 		err = -EBUSY;
 		goto out;
 	}
@@ -788,7 +805,7 @@ struct resource *lookup_resource(struct resource *root, resource_size_t start)
 	struct resource *res;
 
 	read_lock(&resource_lock);
-	for (res = root->child; res; res = res->sibling) {
+	list_for_each_entry(res, &root->child, sibling) {
 		if (res->start == start)
 			break;
 	}
@@ -821,32 +838,27 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 			break;
 	}
 
-	for (next = first; ; next = next->sibling) {
+	for (next = first; ; next = sibling(next)) {
 		/* Partial overlap? Bad, and unfixable */
 		if (next->start < new->start || next->end > new->end)
 			return next;
-		if (!next->sibling)
+		if (!sibling(next))
 			break;
-		if (next->sibling->start > new->end)
+		if (sibling(next)->start > new->end)
 			break;
 	}
-
 	new->parent = parent;
-	new->sibling = next->sibling;
-	new->child = first;
+	list_add(&new->sibling, &next->sibling);
+	INIT_LIST_HEAD(&new->child);
 
-	next->sibling = NULL;
-	for (next = first; next; next = next->sibling)
+	/*
+	 * From first to next, they all fall into new's region, so change them
+	 * as new's children.
+	 */
+	list_cut_position(&new->child, first->sibling.prev, &next->sibling);
+	list_for_each_entry(next, &new->child, sibling)
 		next->parent = new;
 
-	if (parent->child == first) {
-		parent->child = new;
-	} else {
-		next = parent->child;
-		while (next->sibling != first)
-			next = next->sibling;
-		next->sibling = new;
-	}
 	return NULL;
 }
 
@@ -968,19 +980,17 @@ static int __adjust_resource(struct resource *res, resource_size_t start,
 	if ((start < parent->start) || (end > parent->end))
 		goto out;
 
-	if (res->sibling && (res->sibling->start <= end))
+	if (sibling(res) && (sibling(res)->start <= end))
 		goto out;
 
-	tmp = parent->child;
-	if (tmp != res) {
-		while (tmp->sibling != res)
-			tmp = tmp->sibling;
+	if (res->sibling.prev != &parent->child) {
+		tmp = list_prev_entry(res, sibling);
 		if (start <= tmp->end)
 			goto out;
 	}
 
 skip:
-	for (tmp = res->child; tmp; tmp = tmp->sibling)
+	list_for_each_entry(tmp, &res->child, sibling)
 		if ((tmp->start < start) || (tmp->end > end))
 			goto out;
 
@@ -1205,34 +1215,32 @@ EXPORT_SYMBOL(__request_region);
 void __release_region(struct resource *parent, resource_size_t start,
 			resource_size_t n)
 {
-	struct resource **p;
+	struct resource *res;
 	resource_size_t end;
 
-	p = &parent->child;
+	res = first_child(&parent->child);
 	end = start + n - 1;
 
 	write_lock(&resource_lock);
 
 	for (;;) {
-		struct resource *res = *p;
-
 		if (!res)
 			break;
 		if (res->start <= start && res->end >= end) {
 			if (!(res->flags & IORESOURCE_BUSY)) {
-				p = &res->child;
+				res = first_child(&res->child);
 				continue;
 			}
 			if (res->start != start || res->end != end)
 				break;
-			*p = res->sibling;
+			list_del(&res->sibling);
 			write_unlock(&resource_lock);
 			if (res->flags & IORESOURCE_MUXED)
 				wake_up(&muxed_resource_wait);
 			free_resource(res);
 			return;
 		}
-		p = &res->sibling;
+		res = sibling(res);
 	}
 
 	write_unlock(&resource_lock);
@@ -1267,9 +1275,7 @@ EXPORT_SYMBOL(__release_region);
 int release_mem_region_adjustable(struct resource *parent,
 			resource_size_t start, resource_size_t size)
 {
-	struct resource **p;
-	struct resource *res;
-	struct resource *new_res;
+	struct resource *res, *new_res;
 	resource_size_t end;
 	int ret = -EINVAL;
 
@@ -1280,16 +1286,16 @@ int release_mem_region_adjustable(struct resource *parent,
 	/* The alloc_resource() result gets checked later */
 	new_res = alloc_resource(GFP_KERNEL);
 
-	p = &parent->child;
+	res = first_child(&parent->child);
 	write_lock(&resource_lock);
 
-	while ((res = *p)) {
+	while ((res)) {
 		if (res->start >= end)
 			break;
 
 		/* look for the next resource if it does not fit into */
 		if (res->start > start || res->end < end) {
-			p = &res->sibling;
+			res = sibling(res);
 			continue;
 		}
 
@@ -1297,14 +1303,14 @@ int release_mem_region_adjustable(struct resource *parent,
 			break;
 
 		if (!(res->flags & IORESOURCE_BUSY)) {
-			p = &res->child;
+			res = first_child(&res->child);
 			continue;
 		}
 
 		/* found the target resource; let's adjust accordingly */
 		if (res->start == start && res->end == end) {
 			/* free the whole entry */
-			*p = res->sibling;
+			list_del(&res->sibling);
 			free_resource(res);
 			ret = 0;
 		} else if (res->start == start && res->end != end) {
@@ -1327,14 +1333,13 @@ int release_mem_region_adjustable(struct resource *parent,
 			new_res->flags = res->flags;
 			new_res->desc = res->desc;
 			new_res->parent = res->parent;
-			new_res->sibling = res->sibling;
-			new_res->child = NULL;
+			INIT_LIST_HEAD(&new_res->child);
 
 			ret = __adjust_resource(res, res->start,
 						start - res->start);
 			if (ret)
 				break;
-			res->sibling = new_res;
+			list_add(&new_res->sibling, &res->sibling);
 			new_res = NULL;
 		}
 
@@ -1515,7 +1520,7 @@ static int __init reserve_setup(char *str)
 			res->end = io_start + io_num - 1;
 			res->flags |= IORESOURCE_BUSY;
 			res->desc = IORES_DESC_NONE;
-			res->child = NULL;
+			INIT_LIST_HEAD(&res->child);
 			if (request_resource(parent, res) == 0)
 				reserved = x+1;
 		}
@@ -1535,7 +1540,7 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 	loff_t l;
 
 	read_lock(&resource_lock);
-	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+	for (p = first_child(&p->child); p; p = r_next(NULL, p, &l)) {
 		/*
 		 * We can probably skip the resources without
 		 * IORESOURCE_IO attribute?
@@ -1591,7 +1596,7 @@ bool iomem_is_exclusive(u64 addr)
 	addr = addr & PAGE_MASK;
 
 	read_lock(&resource_lock);
-	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+	for (p = first_child(&p->child); p; p = r_next(NULL, p, &l)) {
 		/*
 		 * We can probably skip the resources without
 		 * IORESOURCE_IO attribute?
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
