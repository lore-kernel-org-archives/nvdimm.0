From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/5]  virtio-pmem: Add virtio pmem driver
Date: Wed,  9 Jan 2019 19:20:21 +0530
Message-ID: <20190109135024.14093-3-pagupta@redhat.com>
References: <20190109135024.14093-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190109135024.14093-1-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This patch adds virtio-pmem driver for KVM guest.

Guest reads the persistent memory range information from
Qemu over VIRTIO and registers it on nvdimm_bus. It also
creates a nd_region object with the persistent memory
range information so that existing 'nvdimm/pmem' driver
can reserve this into system memory map. This way
'virtio-pmem' driver uses existing functionality of pmem
driver to register persistent memory compatible for DAX
capable filesystems.

This also provides function to perform guest flush over
VIRTIO from 'pmem' driver when userspace performs flush
on DAX memory range.

Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/nvdimm/virtio_pmem.c     |  84 ++++++++++++++++++++++++++
 drivers/virtio/Kconfig           |  10 ++++
 drivers/virtio/Makefile          |   1 +
 drivers/virtio/pmem.c            | 124 +++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_pmem.h      |  60 +++++++++++++++++++
 include/uapi/linux/virtio_ids.h  |   1 +
 include/uapi/linux/virtio_pmem.h |  10 ++++
 7 files changed, 290 insertions(+)
 create mode 100644 drivers/nvdimm/virtio_pmem.c
 create mode 100644 drivers/virtio/pmem.c
 create mode 100644 include/linux/virtio_pmem.h
 create mode 100644 include/uapi/linux/virtio_pmem.h

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
new file mode 100644
index 0000000..2a1b1ba
--- /dev/null
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * virtio_pmem.c: Virtio pmem Driver
+ *
+ * Discovers persistent memory range information
+ * from host and provides a virtio based flushing
+ * interface.
+ */
+#include <linux/virtio_pmem.h>
+#include "nd.h"
+
+ /* The interrupt handler */
+void host_ack(struct virtqueue *vq)
+{
+	unsigned int len;
+	unsigned long flags;
+	struct virtio_pmem_request *req, *req_buf;
+	struct virtio_pmem *vpmem = vq->vdev->priv;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
+		req->done = true;
+		wake_up(&req->host_acked);
+
+		if (!list_empty(&vpmem->req_list)) {
+			req_buf = list_first_entry(&vpmem->req_list,
+					struct virtio_pmem_request, list);
+			list_del(&vpmem->req_list);
+			req_buf->wq_buf_avail = true;
+			wake_up(&req_buf->wq_buf);
+		}
+	}
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+}
+EXPORT_SYMBOL_GPL(host_ack);
+
+ /* The request submission function */
+int virtio_pmem_flush(struct nd_region *nd_region)
+{
+	int err;
+	unsigned long flags;
+	struct scatterlist *sgs[2], sg, ret;
+	struct virtio_device *vdev = nd_region->provider_data;
+	struct virtio_pmem *vpmem = vdev->priv;
+	struct virtio_pmem_request *req;
+
+	might_sleep();
+	req = kmalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->done = req->wq_buf_avail = false;
+	strcpy(req->name, "FLUSH");
+	init_waitqueue_head(&req->host_acked);
+	init_waitqueue_head(&req->wq_buf);
+	sg_init_one(&sg, req->name, strlen(req->name));
+	sgs[0] = &sg;
+	sg_init_one(&ret, &req->ret, sizeof(req->ret));
+	sgs[1] = &ret;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
+	if (err) {
+		dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");
+
+		list_add_tail(&vpmem->req_list, &req->list);
+		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
+		/* When host has read buffer, this completes via host_ack */
+		wait_event(req->wq_buf, req->wq_buf_avail);
+		spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	}
+	virtqueue_kick(vpmem->req_vq);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
+	/* When host has read buffer, this completes via host_ack */
+	wait_event(req->host_acked, req->done);
+	err = req->ret;
+	kfree(req);
+
+	return err;
+};
+EXPORT_SYMBOL_GPL(virtio_pmem_flush);
+MODULE_LICENSE("GPL");
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 3589764..9f634a2 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -42,6 +42,16 @@ config VIRTIO_PCI_LEGACY
 
 	  If unsure, say Y.
 
+config VIRTIO_PMEM
+	tristate "Support for virtio pmem driver"
+	depends on VIRTIO
+	depends on LIBNVDIMM
+	help
+	This driver provides support for virtio based flushing interface
+	for persistent memory range.
+
+	If unsure, say M.
+
 config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 3a2b5c5..143ce91 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -6,3 +6,4 @@ virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
 obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
+obj-$(CONFIG_VIRTIO_PMEM) += pmem.o ../nvdimm/virtio_pmem.o
diff --git a/drivers/virtio/pmem.c b/drivers/virtio/pmem.c
new file mode 100644
index 0000000..51f5349
--- /dev/null
+++ b/drivers/virtio/pmem.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * virtio_pmem.c: Virtio pmem Driver
+ *
+ * Discovers persistent memory range information
+ * from host and registers the virtual pmem device
+ * with libnvdimm core.
+ */
+#include <linux/virtio_pmem.h>
+#include <../../drivers/nvdimm/nd.h>
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_PMEM, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+ /* Initialize virt queue */
+static int init_vq(struct virtio_pmem *vpmem)
+{
+	struct virtqueue *vq;
+
+	/* single vq */
+	vpmem->req_vq = vq = virtio_find_single_vq(vpmem->vdev,
+				host_ack, "flush_queue");
+	if (IS_ERR(vq))
+		return PTR_ERR(vq);
+
+	spin_lock_init(&vpmem->pmem_lock);
+	INIT_LIST_HEAD(&vpmem->req_list);
+
+	return 0;
+};
+
+static int virtio_pmem_probe(struct virtio_device *vdev)
+{
+	int err = 0;
+	struct resource res;
+	struct virtio_pmem *vpmem;
+	struct nvdimm_bus *nvdimm_bus;
+	struct nd_region_desc ndr_desc;
+	int nid = dev_to_node(&vdev->dev);
+	struct nd_region *nd_region;
+
+	if (!vdev->config->get) {
+		dev_err(&vdev->dev, "%s failure: config disabled\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	vdev->priv = vpmem = devm_kzalloc(&vdev->dev, sizeof(*vpmem),
+			GFP_KERNEL);
+	if (!vpmem) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	vpmem->vdev = vdev;
+	err = init_vq(vpmem);
+	if (err)
+		goto out_err;
+
+	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
+			start, &vpmem->start);
+	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
+			size, &vpmem->size);
+
+	res.start = vpmem->start;
+	res.end   = vpmem->start + vpmem->size-1;
+	vpmem->nd_desc.provider_name = "virtio-pmem";
+	vpmem->nd_desc.module = THIS_MODULE;
+
+	vpmem->nvdimm_bus = nvdimm_bus = nvdimm_bus_register(&vdev->dev,
+						&vpmem->nd_desc);
+	if (!nvdimm_bus)
+		goto out_vq;
+
+	dev_set_drvdata(&vdev->dev, nvdimm_bus);
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+
+	ndr_desc.res = &res;
+	ndr_desc.numa_node = nid;
+	ndr_desc.flush = virtio_pmem_flush;
+	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
+	nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
+	nd_region->provider_data =  dev_to_virtio
+					(nd_region->dev.parent->parent);
+
+	if (!nd_region)
+		goto out_nd;
+
+	//virtio_device_ready(vdev);
+	return 0;
+out_nd:
+	err = -ENXIO;
+	nvdimm_bus_unregister(nvdimm_bus);
+out_vq:
+	vdev->config->del_vqs(vdev);
+out_err:
+	dev_err(&vdev->dev, "failed to register virtio pmem memory\n");
+	return err;
+}
+
+static void virtio_pmem_remove(struct virtio_device *vdev)
+{
+	struct virtio_pmem *vpmem = vdev->priv;
+	struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
+
+	nvdimm_bus_unregister(nvdimm_bus);
+	vdev->config->del_vqs(vdev);
+	kfree(vpmem);
+}
+
+static struct virtio_driver virtio_pmem_driver = {
+	.driver.name		= KBUILD_MODNAME,
+	.driver.owner		= THIS_MODULE,
+	.id_table		= id_table,
+	.probe			= virtio_pmem_probe,
+	.remove			= virtio_pmem_remove,
+};
+
+module_virtio_driver(virtio_pmem_driver);
+MODULE_DEVICE_TABLE(virtio, id_table);
+MODULE_DESCRIPTION("Virtio pmem driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio_pmem.h b/include/linux/virtio_pmem.h
new file mode 100644
index 0000000..224f9d9
--- /dev/null
+++ b/include/linux/virtio_pmem.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * virtio_pmem.h: virtio pmem Driver
+ *
+ * Discovers persistent memory range information
+ * from host and provides a virtio based flushing
+ * interface.
+ **/
+
+#ifndef _LINUX_VIRTIO_PMEM_H
+#define _LINUX_VIRTIO_PMEM_H
+
+#include <linux/virtio_ids.h>
+#include <linux/module.h>
+#include <linux/virtio_config.h>
+#include <uapi/linux/virtio_pmem.h>
+#include <linux/libnvdimm.h>
+#include <linux/spinlock.h>
+
+struct virtio_pmem_request {
+	/* Host return status corresponding to flush request */
+	int ret;
+
+	/* command name*/
+	char name[16];
+
+	/* Wait queue to process deferred work after ack from host */
+	wait_queue_head_t host_acked;
+	bool done;
+
+	/* Wait queue to process deferred work after virt queue buffer avail */
+	wait_queue_head_t wq_buf;
+	bool wq_buf_avail;
+	struct list_head list;
+};
+
+struct virtio_pmem {
+	struct virtio_device *vdev;
+
+	/* Virtio pmem request queue */
+	struct virtqueue *req_vq;
+
+	/* nvdimm bus registers virtio pmem device */
+	struct nvdimm_bus *nvdimm_bus;
+	struct nvdimm_bus_descriptor nd_desc;
+
+	/* List to store deferred work if virtqueue is full */
+	struct list_head req_list;
+
+	/* Synchronize virtqueue data */
+	spinlock_t pmem_lock;
+
+	/* Memory region information */
+	uint64_t start;
+	uint64_t size;
+};
+
+void host_ack(struct virtqueue *vq);
+int virtio_pmem_flush(struct nd_region *nd_region);
+#endif
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 6d5c3b2..3463895 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -43,5 +43,6 @@
 #define VIRTIO_ID_INPUT        18 /* virtio input */
 #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
 #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
+#define VIRTIO_ID_PMEM         25 /* virtio pmem */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/uapi/linux/virtio_pmem.h b/include/uapi/linux/virtio_pmem.h
new file mode 100644
index 0000000..fa3f7d5
--- /dev/null
+++ b/include/uapi/linux/virtio_pmem.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _UAPI_LINUX_VIRTIO_PMEM_H
+#define _UAPI_LINUX_VIRTIO_PMEM_H
+
+struct virtio_pmem_config {
+	__le64 start;
+	__le64 size;
+};
+#endif
-- 
2.9.3
