Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AE4D21A0481C
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 15:13:23 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Mar 2017 16:12:32 -0600
Message-Id: <1490911959-5146-2-git-send-email-logang@deltatee.com>
In-Reply-To: <1490911959-5146-1-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Subject: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
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
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

A p2pmem device is simply a PCI card with a BAR space that points to
regular memory. This may be an independent PCI card or part of another
completely unrelated device (like an IB card or a NVMe card). The
p2pmem device is designed such that other drivers may register p2pmem
memory for use by the system.

p2pmem devices then provide a kernel interface so that other subsystems
can allocate chunks of this memory as necessary to facilitate transfers
between two PCI peers. Depending on hardware, this may reduce the
bandwidth of the transfer but could significantly reduce presure
on system memory. This may be desirable in many cases: for example a
system could be designed with a small CPU connected to a PCI switch by a
small number of lanes which would maximize the number of lanes available
to connect to NVME devices.

Seeing using p2p memory can often have negative effects, especially
with older PCI root complexes. The code is designed to only utilize the
p2pmem device if all the devices involved in a transfer are behind the
same PCI switch. Other cases may still work or be desirable for some
end users but it was decided this would be the best course of action
to prevent users enabling it and wondering why their performance
dropped.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/memory/Kconfig  |   5 +
 drivers/memory/Makefile |   2 +
 drivers/memory/p2pmem.c | 403 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/p2pmem.h  | 103 +++++++++++++
 4 files changed, 513 insertions(+)
 create mode 100644 drivers/memory/p2pmem.c
 create mode 100644 include/linux/p2pmem.h

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index ec80e35..4a02cd3 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -146,3 +146,8 @@ source "drivers/memory/samsung/Kconfig"
 source "drivers/memory/tegra/Kconfig"
 
 endif
+
+config P2PMEM
+	bool "Peer 2 Peer Memory Device Support"
+	help
+	  This driver is for peer 2 peer memory device managers.
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index e88097fb..260bfe9 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -21,3 +21,5 @@ obj-$(CONFIG_DA8XX_DDRCTL)	+= da8xx-ddrctl.o
 
 obj-$(CONFIG_SAMSUNG_MC)	+= samsung/
 obj-$(CONFIG_TEGRA_MC)		+= tegra/
+
+obj-$(CONFIG_P2PMEM)        += p2pmem.o
diff --git a/drivers/memory/p2pmem.c b/drivers/memory/p2pmem.c
new file mode 100644
index 0000000..c4ea311
--- /dev/null
+++ b/drivers/memory/p2pmem.c
@@ -0,0 +1,403 @@
+/*
+ * Peer 2 Peer Memory Device
+ * Copyright (c) 2016, Microsemi Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/p2pmem.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/genalloc.h>
+#include <linux/memremap.h>
+
+MODULE_DESCRIPTION("Peer 2 Peer Memory Device");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Microsemi Corporation");
+
+static struct class *p2pmem_class;
+static DEFINE_IDA(p2pmem_ida);
+
+static struct p2pmem_dev *to_p2pmem(struct device *dev)
+{
+	return container_of(dev, struct p2pmem_dev, dev);
+}
+
+static void p2pmem_percpu_release(struct percpu_ref *ref)
+{
+	struct p2pmem_dev *p = container_of(ref, struct p2pmem_dev, ref);
+
+	complete_all(&p->cmp);
+}
+
+static void p2pmem_percpu_exit(void *data)
+{
+	struct percpu_ref *ref = data;
+
+	percpu_ref_exit(ref);
+}
+
+static void p2pmem_percpu_kill(void *data)
+{
+	struct percpu_ref *ref = data;
+	struct p2pmem_dev *p = container_of(ref, struct p2pmem_dev, ref);
+
+	if (percpu_ref_is_dying(ref))
+		return;
+
+	percpu_ref_kill(ref);
+	wait_for_completion(&p->cmp);
+}
+
+static void p2pmem_release(struct device *dev)
+{
+	struct p2pmem_dev *p = to_p2pmem(dev);
+
+	if (p->pool)
+		gen_pool_destroy(p->pool);
+
+	kfree(p);
+}
+
+/**
+ * p2pmem_create() - create a new p2pmem device
+ * @parent: the parent device to create it under
+ *
+ * Return value is a pointer to the new device or an ERR_PTR
+ * on failure.
+ */
+struct p2pmem_dev *p2pmem_create(struct device *parent)
+{
+	struct p2pmem_dev *p;
+	int nid = dev_to_node(parent);
+	int rc;
+
+	p = kzalloc_node(sizeof(*p), GFP_KERNEL, nid);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	init_completion(&p->cmp);
+	device_initialize(&p->dev);
+	p->dev.class = p2pmem_class;
+	p->dev.parent = parent;
+	p->dev.release = p2pmem_release;
+
+	p->id = ida_simple_get(&p2pmem_ida, 0, 0, GFP_KERNEL);
+	if (p->id < 0) {
+		rc = p->id;
+		goto err_free;
+	}
+
+	dev_set_name(&p->dev, "p2pmem%d", p->id);
+
+	p->pool = gen_pool_create(PAGE_SHIFT, nid);
+	if (!p->pool) {
+		rc = -ENOMEM;
+		goto err_id;
+	}
+
+	rc = percpu_ref_init(&p->ref, p2pmem_percpu_release, 0,
+			     GFP_KERNEL);
+	if (rc)
+		goto err_id;
+
+	rc = devm_add_action_or_reset(&p->dev, p2pmem_percpu_exit, &p->ref);
+	if (rc)
+		goto err_id;
+
+	rc = device_add(&p->dev);
+	if (rc)
+		goto err_id;
+
+	dev_info(&p->dev, "registered");
+
+	return p;
+
+err_id:
+	ida_simple_remove(&p2pmem_ida, p->id);
+err_free:
+	put_device(&p->dev);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL(p2pmem_create);
+
+/**
+ * p2pmem_unregister() - unregister a p2pmem device
+ * @p: the device to unregister
+ *
+ * The device will remain until all users are done with it
+ */
+void p2pmem_unregister(struct p2pmem_dev *p)
+{
+	if (!p)
+		return;
+
+	dev_info(&p->dev, "unregistered");
+	device_del(&p->dev);
+	ida_simple_remove(&p2pmem_ida, p->id);
+	put_device(&p->dev);
+}
+EXPORT_SYMBOL(p2pmem_unregister);
+
+/**
+ * p2pmem_add_resource() - add memory for use as p2pmem to the device
+ * @p: the device to add the memory to
+ * @res: resource describing the memory
+ *
+ * The memory will be given ZONE_DEVICE struct pages so that it may
+ * be used with any dma request.
+ */
+int p2pmem_add_resource(struct p2pmem_dev *p, struct resource *res)
+{
+	int rc;
+	void *addr;
+	int nid = dev_to_node(&p->dev);
+
+	addr = devm_memremap_pages(&p->dev, res, &p->ref, NULL);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
+	rc = gen_pool_add_virt(p->pool, (unsigned long)addr,
+			       res->start, resource_size(res), nid);
+	if (rc)
+		return rc;
+
+	rc = devm_add_action_or_reset(&p->dev, p2pmem_percpu_kill, &p->ref);
+	if (rc)
+		return rc;
+
+	dev_info(&p->dev, "added %pR", res);
+
+	return 0;
+}
+EXPORT_SYMBOL(p2pmem_add_resource);
+
+struct pci_region {
+	struct pci_dev *pdev;
+	int bar;
+};
+
+static void p2pmem_release_pci_region(void *data)
+{
+	struct pci_region *r = data;
+
+	pci_release_region(r->pdev, r->bar);
+	kfree(r);
+}
+
+/**
+ * p2pmem_add_pci_region() - request and add an entire PCI region to the
+ *	specified p2pmem device
+ * @p: the device to add the memory to
+ * @pdev: pci device to register the bar from
+ * @bar: the bar number to add
+ *
+ * The memory will be given ZONE_DEVICE struct pages so that it may
+ * be used with any dma request.
+ */
+int p2pmem_add_pci_region(struct p2pmem_dev *p, struct pci_dev *pdev, int bar)
+{
+	int rc;
+	struct pci_region *r;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return -ENOMEM;
+
+	r->pdev = pdev;
+	r->bar = bar;
+
+	rc = pci_request_region(pdev, bar, dev_name(&p->dev));
+	if (rc < 0)
+		goto err_pci;
+
+	rc = p2pmem_add_resource(p, &pdev->resource[bar]);
+	if (rc < 0)
+		goto err_add;
+
+	rc = devm_add_action_or_reset(&p->dev, p2pmem_release_pci_region, r);
+	if (rc)
+		return rc;
+
+	return 0;
+
+err_add:
+	pci_release_region(pdev, bar);
+err_pci:
+	kfree(r);
+	return rc;
+}
+EXPORT_SYMBOL(p2pmem_add_pci_region);
+
+/**
+ * p2pmem_alloc() - allocate some p2p memory
+ * @p: the device to allocate memory from
+ * @size: number of bytes to allocate
+ *
+ * Returns the allocated memory or NULL on error
+ */
+void *p2pmem_alloc(struct p2pmem_dev *p, size_t size)
+{
+	return (void *)gen_pool_alloc(p->pool, size);
+}
+EXPORT_SYMBOL(p2pmem_alloc);
+
+/**
+ * p2pmem_free() - free allocated p2p memory
+ * @p: the device the memory was allocated from
+ * @addr: address of the memory that was allocated
+ * @size: number of bytes that was allocated
+ */
+void p2pmem_free(struct p2pmem_dev *p, void *addr, size_t size)
+{
+	gen_pool_free(p->pool, (unsigned long)addr, size);
+}
+EXPORT_SYMBOL(p2pmem_free);
+
+static struct device *find_parent_pci_dev(struct device *dev)
+{
+	while (dev) {
+		if (dev_is_pci(dev))
+			return dev;
+
+		dev = dev->parent;
+	}
+
+	return NULL;
+}
+
+/*
+ * If a device is behind a switch, we try to find the upstream bridge
+ * port of the switch. This requires two calls to pci_upstream_bridge:
+ * one for the upstream port on the switch, one on the upstream port
+ * for the next level in the hierarchy. Because of this, devices connected
+ * to the root port will be rejected.
+ */
+static struct pci_dev *get_upstream_switch_port(struct device *dev)
+{
+	struct device *dpci;
+	struct pci_dev *pci;
+
+	dpci = find_parent_pci_dev(dev);
+	if (!dpci)
+		return NULL;
+
+	pci = pci_upstream_bridge(to_pci_dev(dpci));
+	if (!pci)
+		return NULL;
+
+	return pci_upstream_bridge(pci);
+}
+
+static int upstream_bridges_match(struct device *p2pmem,
+				  const void *data)
+{
+	struct device * const *dma_devices = data;
+	struct pci_dev *p2p_up;
+	struct pci_dev *dma_up;
+
+	p2p_up = get_upstream_switch_port(p2pmem);
+	if (!p2p_up) {
+		dev_warn(p2pmem, "p2pmem is not behind a pci switch");
+		return false;
+	}
+
+	while (*dma_devices) {
+		dma_up = get_upstream_switch_port(*dma_devices);
+
+		if (!dma_up) {
+			dev_dbg(p2pmem, "%s is not a pci device behind a switch",
+				dev_name(*dma_devices));
+			return false;
+		}
+
+		if (p2p_up != dma_up) {
+			dev_dbg(p2pmem,
+				"%s does not reside on the same upstream bridge",
+				dev_name(*dma_devices));
+			return false;
+		}
+
+		dev_dbg(p2pmem, "%s is compatible", dev_name(*dma_devices));
+		dma_devices++;
+	}
+
+	return true;
+}
+
+/**
+ * p2pmem_find_compat() - find a p2pmem device compatible with the
+ *	specified devices
+ * @dma_devices: a null terminated array of device pointers which
+ *	all must be compatible with the returned p2pmem device
+ *
+ * For now, we only support cases where all the devices that
+ * will transfer to the p2pmem device are on the same switch.
+ * This cuts out cases that may work but is safest for the user.
+ * We also do not presently support cases where two devices
+ * are behind multiple levels of switches even though this would
+ * likely work fine.
+ *
+ * Future work could be done to whitelist root ports that are known
+ * to be good and support many levels of switches. Additionally,
+ * it would make sense to choose the topographically closest p2pmem
+ * for a given setup. (Presently we only return the first that matches.)
+ *
+ * Returns a pointer to the p2pmem device with the reference taken
+ * (use p2pmem_put to return the reference) or NULL if no compatible
+ * p2pmem device is found.
+ */
+struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devices)
+{
+	struct device *dev;
+
+	dev = class_find_device(p2pmem_class, NULL, dma_devices,
+				upstream_bridges_match);
+
+	if (!dev)
+		return NULL;
+
+	return to_p2pmem(dev);
+}
+EXPORT_SYMBOL(p2pmem_find_compat);
+
+/**
+ * p2pmem_put() - decrement a p2pmem device reference
+ * @p: p2pmem device to return
+ *
+ * Dereference and free (if last) the device's reference counter.
+ * It's safe to pass a NULL pointer to this function.
+ */
+void p2pmem_put(struct p2pmem_dev *p)
+{
+	if (p)
+		put_device(&p->dev);
+}
+EXPORT_SYMBOL(p2pmem_put);
+
+static int __init p2pmem_init(void)
+{
+	p2pmem_class = class_create(THIS_MODULE, "p2pmem");
+	if (IS_ERR(p2pmem_class))
+		return PTR_ERR(p2pmem_class);
+
+	return 0;
+}
+module_init(p2pmem_init);
+
+static void __exit p2pmem_exit(void)
+{
+	class_destroy(p2pmem_class);
+
+	pr_info(KBUILD_MODNAME ": unloaded.\n");
+}
+module_exit(p2pmem_exit);
diff --git a/include/linux/p2pmem.h b/include/linux/p2pmem.h
new file mode 100644
index 0000000..71dc1e1
--- /dev/null
+++ b/include/linux/p2pmem.h
@@ -0,0 +1,103 @@
+/*
+ * Peer 2 Peer Memory Device
+ * Copyright (c) 2016, Microsemi Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __P2PMEM_H__
+#define __P2PMEM_H__
+
+#include <linux/device.h>
+#include <linux/pci.h>
+
+struct p2pmem_dev {
+	struct device dev;
+	int id;
+
+	struct percpu_ref ref;
+	struct completion cmp;
+	struct gen_pool *pool;
+};
+
+#ifdef CONFIG_P2PMEM
+
+struct p2pmem_dev *p2pmem_create(struct device *parent);
+void p2pmem_unregister(struct p2pmem_dev *p);
+
+int p2pmem_add_resource(struct p2pmem_dev *p, struct resource *res);
+int p2pmem_add_pci_region(struct p2pmem_dev *p, struct pci_dev *pdev, int bar);
+
+void *p2pmem_alloc(struct p2pmem_dev *p, size_t size);
+void p2pmem_free(struct p2pmem_dev *p, void *addr, size_t size);
+
+struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devices);
+void p2pmem_put(struct p2pmem_dev *p);
+
+#else
+
+static inline void *p2pmem_create(struct device *parent)
+{
+	return NULL;
+}
+
+static inline void p2pmem_unregister(struct p2pmem_dev *p)
+{
+}
+
+static inline int p2pmem_add_resource(struct p2pmem_dev *p,
+				      struct resource *res)
+{
+	return -ENODEV;
+}
+
+static inline int p2pmem_add_pci_region(struct p2pmem_dev *p,
+					struct pci_dev *pdev, int bar)
+{
+	return -ENODEV;
+}
+
+static inline void *p2pmem_alloc(struct p2pmem_dev *p, size_t size)
+{
+	return NULL;
+}
+
+static inline void p2pmem_free(struct p2pmem_dev *p, void *addr, size_t size)
+{
+}
+
+static inline struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devs)
+{
+	return NULL;
+}
+
+static inline void p2pmem_put(struct p2pmem_dev *p)
+{
+}
+
+#endif
+
+static inline struct page *p2pmem_alloc_page(struct p2pmem_dev *p)
+{
+	struct page *pg = p2pmem_alloc(p, PAGE_SIZE);
+
+	if (pg)
+		return virt_to_page(pg);
+
+	return NULL;
+}
+
+static inline void p2pmem_free_page(struct p2pmem_dev *p, struct page *pg)
+{
+	p2pmem_free(p, page_to_virt(pg), PAGE_SIZE);
+}
+
+#endif
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
