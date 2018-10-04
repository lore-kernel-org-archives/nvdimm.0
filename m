Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08C0821959CB2
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 14:28:01 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu,  4 Oct 2018 15:27:47 -0600
Message-Id: <20181004212747.6301-14-logang@deltatee.com>
In-Reply-To: <20181004212747.6301-1-logang@deltatee.com>
References: <20181004212747.6301-1-logang@deltatee.com>
MIME-Version: 1.0
Subject: [PATCH v9 13/13] nvmet: Optionally use PCI P2P memory
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
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

We create a configfs attribute in each nvme-fabrics namespace to
enable P2P memory use. The attribute may be enabled (with a boolean)
or a specific P2P device may be given (with the device's PCI name).

When enabled, the namespace will ensure the underlying block device
supports P2P and that it is compatible with any specified P2P device.
If no device was specified it will ensure there is compatible P2P memory
somewhere in the system. Enabling an namespace with P2P memory will fail
with EINVAL (and an appropriate dmesg error) if any of these conditions
are not met.

Once a controller is setup on a specific port, the P2P device to use
for each namespace will be found and stored in a radix tree by
namespace ID. When memory is allocated for a request, the tree is used
to look up the P2P device to allocate memory against. If no device is in
the tree (because no appropriate device was found), or if allocation of
P2P memory fails, the system will fall back to using regular memory.

Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
[hch: partial rewrite of the initial code]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/target/configfs.c    |  45 ++++++++
 drivers/nvme/target/core.c        | 164 +++++++++++++++++++++++++++++-
 drivers/nvme/target/io-cmd-bdev.c |   3 +
 drivers/nvme/target/nvmet.h       |  15 +++
 drivers/nvme/target/rdma.c        |   2 +
 5 files changed, 228 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index b37a8e3e3f80..72e7e356fed2 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -17,6 +17,8 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
+#include <linux/pci.h>
+#include <linux/pci-p2pdma.h>
 
 #include "nvmet.h"
 
@@ -340,6 +342,46 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 
 CONFIGFS_ATTR(nvmet_ns_, device_path);
 
+#ifdef CONFIG_PCI_P2PDMA
+static ssize_t nvmet_ns_p2pmem_show(struct config_item *item, char *page)
+{
+	struct nvmet_ns *ns = to_nvmet_ns(item);
+
+	return pci_p2pdma_enable_show(page, ns->p2p_dev, ns->use_p2pmem);
+}
+
+static ssize_t nvmet_ns_p2pmem_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_ns *ns = to_nvmet_ns(item);
+	struct pci_dev *p2p_dev = NULL;
+	bool use_p2pmem;
+	int error;
+	int ret = count;
+
+	mutex_lock(&ns->subsys->lock);
+	if (ns->enabled) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	error = pci_p2pdma_enable_store(page, &p2p_dev, &use_p2pmem);
+	if (error)
+		return error;
+
+	ns->use_p2pmem = use_p2pmem;
+	pci_dev_put(ns->p2p_dev);
+	ns->p2p_dev = p2p_dev;
+
+out_unlock:
+	mutex_unlock(&ns->subsys->lock);
+
+	return ret;
+}
+
+CONFIGFS_ATTR(nvmet_ns_, p2pmem);
+#endif /* CONFIG_PCI_P2PDMA */
+
 static ssize_t nvmet_ns_device_uuid_show(struct config_item *item, char *page)
 {
 	return sprintf(page, "%pUb\n", &to_nvmet_ns(item)->uuid);
@@ -509,6 +551,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
 	&nvmet_ns_attr_ana_grpid,
 	&nvmet_ns_attr_enable,
 	&nvmet_ns_attr_buffered_io,
+#ifdef CONFIG_PCI_P2PDMA
+	&nvmet_ns_attr_p2pmem,
+#endif
 	NULL,
 };
 
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 310b9fb54f6a..d9e273ada36d 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/rculist.h>
+#include <linux/pci-p2pdma.h>
 
 #include "nvmet.h"
 
@@ -365,9 +366,93 @@ static void nvmet_ns_dev_disable(struct nvmet_ns *ns)
 	nvmet_file_ns_disable(ns);
 }
 
+static int nvmet_p2pmem_ns_enable(struct nvmet_ns *ns)
+{
+	int ret;
+	struct pci_dev *p2p_dev;
+
+	if (!ns->use_p2pmem)
+		return 0;
+
+	if (!ns->bdev) {
+		pr_err("peer-to-peer DMA is not supported by non-block device namespaces\n");
+		return -EINVAL;
+	}
+
+	if (!blk_queue_pci_p2pdma(ns->bdev->bd_queue)) {
+		pr_err("peer-to-peer DMA is not supported by the driver of %s\n",
+		       ns->device_path);
+		return -EINVAL;
+	}
+
+	if (ns->p2p_dev) {
+		ret = pci_p2pdma_distance(ns->p2p_dev, nvmet_ns_dev(ns), true);
+		if (ret < 0)
+			return -EINVAL;
+	} else {
+		/*
+		 * Right now we just check that there is p2pmem available so
+		 * we can report an error to the user right away if there
+		 * is not. We'll find the actual device to use once we
+		 * setup the controller when the port's device is available.
+		 */
+
+		p2p_dev = pci_p2pmem_find(nvmet_ns_dev(ns));
+		if (!p2p_dev) {
+			pr_err("no peer-to-peer memory is available for %s\n",
+			       ns->device_path);
+			return -EINVAL;
+		}
+
+		pci_dev_put(p2p_dev);
+	}
+
+	return 0;
+}
+
+/*
+ * Note: ctrl->subsys->lock should be held when calling this function
+ */
+static void nvmet_p2pmem_ns_add_p2p(struct nvmet_ctrl *ctrl,
+				    struct nvmet_ns *ns)
+{
+	struct device *clients[2];
+	struct pci_dev *p2p_dev;
+	int ret;
+
+	if (!ctrl->p2p_client)
+		return;
+
+	if (ns->p2p_dev) {
+		ret = pci_p2pdma_distance(ns->p2p_dev, ctrl->p2p_client, true);
+		if (ret < 0)
+			return;
+
+		p2p_dev = pci_dev_get(ns->p2p_dev);
+	} else {
+		clients[0] = ctrl->p2p_client;
+		clients[1] = nvmet_ns_dev(ns);
+
+		p2p_dev = pci_p2pmem_find_many(clients, ARRAY_SIZE(clients));
+		if (!p2p_dev) {
+			pr_err("no peer-to-peer memory is available that's supported by %s and %s\n",
+			       dev_name(ctrl->p2p_client), ns->device_path);
+			return;
+		}
+	}
+
+	ret = radix_tree_insert(&ctrl->p2p_ns_map, ns->nsid, p2p_dev);
+	if (ret < 0)
+		pci_dev_put(p2p_dev);
+
+	pr_info("using p2pmem on %s for nsid %d\n", pci_name(p2p_dev),
+		ns->nsid);
+}
+
 int nvmet_ns_enable(struct nvmet_ns *ns)
 {
 	struct nvmet_subsys *subsys = ns->subsys;
+	struct nvmet_ctrl *ctrl;
 	int ret;
 
 	mutex_lock(&subsys->lock);
@@ -384,6 +469,13 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	if (ret)
 		goto out_unlock;
 
+	ret = nvmet_p2pmem_ns_enable(ns);
+	if (ret)
+		goto out_unlock;
+
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
+		nvmet_p2pmem_ns_add_p2p(ctrl, ns);
+
 	ret = percpu_ref_init(&ns->ref, nvmet_destroy_namespace,
 				0, GFP_KERNEL);
 	if (ret)
@@ -418,6 +510,9 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	mutex_unlock(&subsys->lock);
 	return ret;
 out_dev_put:
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
+		pci_dev_put(radix_tree_delete(&ctrl->p2p_ns_map, ns->nsid));
+
 	nvmet_ns_dev_disable(ns);
 	goto out_unlock;
 }
@@ -425,6 +520,7 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 void nvmet_ns_disable(struct nvmet_ns *ns)
 {
 	struct nvmet_subsys *subsys = ns->subsys;
+	struct nvmet_ctrl *ctrl;
 
 	mutex_lock(&subsys->lock);
 	if (!ns->enabled)
@@ -434,6 +530,10 @@ void nvmet_ns_disable(struct nvmet_ns *ns)
 	list_del_rcu(&ns->dev_link);
 	if (ns->nsid == subsys->max_nsid)
 		subsys->max_nsid = nvmet_max_nsid(subsys);
+
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
+		pci_dev_put(radix_tree_delete(&ctrl->p2p_ns_map, ns->nsid));
+
 	mutex_unlock(&subsys->lock);
 
 	/*
@@ -450,6 +550,7 @@ void nvmet_ns_disable(struct nvmet_ns *ns)
 	percpu_ref_exit(&ns->ref);
 
 	mutex_lock(&subsys->lock);
+
 	subsys->nr_namespaces--;
 	nvmet_ns_changed(subsys, ns->nsid);
 	nvmet_ns_dev_disable(ns);
@@ -727,6 +828,29 @@ EXPORT_SYMBOL_GPL(nvmet_req_execute);
 
 int nvmet_req_alloc_sgl(struct nvmet_req *req)
 {
+	struct pci_dev *p2p_dev = NULL;
+
+	if (IS_ENABLED(CONFIG_PCI_P2PDMA)) {
+		if (req->sq->ctrl && req->ns)
+			p2p_dev = radix_tree_lookup(&req->sq->ctrl->p2p_ns_map,
+						    req->ns->nsid);
+
+		req->p2p_dev = NULL;
+		if (req->sq->qid && p2p_dev) {
+			req->sg = pci_p2pmem_alloc_sgl(p2p_dev, &req->sg_cnt,
+						       req->transfer_len);
+			if (req->sg) {
+				req->p2p_dev = p2p_dev;
+				return 0;
+			}
+		}
+
+		/*
+		 * If no P2P memory was available we fallback to using
+		 * regular memory
+		 */
+	}
+
 	req->sg = sgl_alloc(req->transfer_len, GFP_KERNEL, &req->sg_cnt);
 	if (!req->sg)
 		return -ENOMEM;
@@ -737,7 +861,11 @@ EXPORT_SYMBOL_GPL(nvmet_req_alloc_sgl);
 
 void nvmet_req_free_sgl(struct nvmet_req *req)
 {
-	sgl_free(req->sg);
+	if (req->p2p_dev)
+		pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	else
+		sgl_free(req->sg);
+
 	req->sg = NULL;
 	req->sg_cnt = 0;
 }
@@ -939,6 +1067,37 @@ bool nvmet_host_allowed(struct nvmet_req *req, struct nvmet_subsys *subsys,
 		return __nvmet_host_allowed(subsys, hostnqn);
 }
 
+/*
+ * Note: ctrl->subsys->lock should be held when calling this function
+ */
+static void nvmet_setup_p2p_ns_map(struct nvmet_ctrl *ctrl,
+		struct nvmet_req *req)
+{
+	struct nvmet_ns *ns;
+
+	if (!req->p2p_client)
+		return;
+
+	ctrl->p2p_client = get_device(req->p2p_client);
+
+	list_for_each_entry_rcu(ns, &ctrl->subsys->namespaces, dev_link)
+		nvmet_p2pmem_ns_add_p2p(ctrl, ns);
+}
+
+/*
+ * Note: ctrl->subsys->lock should be held when calling this function
+ */
+static void nvmet_release_p2p_ns_map(struct nvmet_ctrl *ctrl)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+
+	radix_tree_for_each_slot(slot, &ctrl->p2p_ns_map, &iter, 0)
+		pci_dev_put(radix_tree_deref_slot(slot));
+
+	put_device(ctrl->p2p_client);
+}
+
 u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		struct nvmet_req *req, u32 kato, struct nvmet_ctrl **ctrlp)
 {
@@ -980,6 +1139,7 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 
 	INIT_WORK(&ctrl->async_event_work, nvmet_async_event_work);
 	INIT_LIST_HEAD(&ctrl->async_events);
+	INIT_RADIX_TREE(&ctrl->p2p_ns_map, GFP_KERNEL);
 
 	memcpy(ctrl->subsysnqn, subsysnqn, NVMF_NQN_SIZE);
 	memcpy(ctrl->hostnqn, hostnqn, NVMF_NQN_SIZE);
@@ -1044,6 +1204,7 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 
 	mutex_lock(&subsys->lock);
 	list_add_tail(&ctrl->subsys_entry, &subsys->ctrls);
+	nvmet_setup_p2p_ns_map(ctrl, req);
 	mutex_unlock(&subsys->lock);
 
 	*ctrlp = ctrl;
@@ -1071,6 +1232,7 @@ static void nvmet_ctrl_free(struct kref *ref)
 	struct nvmet_subsys *subsys = ctrl->subsys;
 
 	mutex_lock(&subsys->lock);
+	nvmet_release_p2p_ns_map(ctrl);
 	list_del(&ctrl->subsys_entry);
 	mutex_unlock(&subsys->lock);
 
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 7bc9f6240432..5660dd7ca755 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -78,6 +78,9 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 		op = REQ_OP_READ;
 	}
 
+	if (is_pci_p2pdma_page(sg_page(req->sg)))
+		op_flags |= REQ_NOMERGE;
+
 	sector = le64_to_cpu(req->cmd->rw.slba);
 	sector <<= (req->ns->blksize_shift - 9);
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index e7b7406c4e22..4333e2c5b4f5 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -26,6 +26,7 @@
 #include <linux/configfs.h>
 #include <linux/rcupdate.h>
 #include <linux/blkdev.h>
+#include <linux/radix-tree.h>
 
 #define NVMET_ASYNC_EVENTS		4
 #define NVMET_ERROR_LOG_SLOTS		128
@@ -77,6 +78,9 @@ struct nvmet_ns {
 	struct completion	disable_done;
 	mempool_t		*bvec_pool;
 	struct kmem_cache	*bvec_cache;
+
+	int			use_p2pmem;
+	struct pci_dev		*p2p_dev;
 };
 
 static inline struct nvmet_ns *to_nvmet_ns(struct config_item *item)
@@ -84,6 +88,11 @@ static inline struct nvmet_ns *to_nvmet_ns(struct config_item *item)
 	return container_of(to_config_group(item), struct nvmet_ns, group);
 }
 
+static inline struct device *nvmet_ns_dev(struct nvmet_ns *ns)
+{
+	return disk_to_dev(ns->bdev->bd_disk);
+}
+
 struct nvmet_cq {
 	u16			qid;
 	u16			size;
@@ -184,6 +193,9 @@ struct nvmet_ctrl {
 
 	char			subsysnqn[NVMF_NQN_FIELD_LEN];
 	char			hostnqn[NVMF_NQN_FIELD_LEN];
+
+	struct device *p2p_client;
+	struct radix_tree_root p2p_ns_map;
 };
 
 struct nvmet_subsys {
@@ -294,6 +306,9 @@ struct nvmet_req {
 
 	void (*execute)(struct nvmet_req *req);
 	const struct nvmet_fabrics_ops *ops;
+
+	struct pci_dev *p2p_dev;
+	struct device *p2p_client;
 };
 
 extern struct workqueue_struct *buffered_io_wq;
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 9e091e78a2f0..3f7971d3706d 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -749,6 +749,8 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 		cmd->send_sge.addr, cmd->send_sge.length,
 		DMA_TO_DEVICE);
 
+	cmd->req.p2p_client = &queue->dev->device->dev;
+
 	if (!nvmet_req_init(&cmd->req, &queue->nvme_cq,
 			&queue->nvme_sq, &nvmet_rdma_ops))
 		return;
-- 
2.19.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
