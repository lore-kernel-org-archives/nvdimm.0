Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84FDC21A0480D
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 15:13:21 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Mar 2017 16:12:38 -0600
Message-Id: <1490911959-5146-8-git-send-email-logang@deltatee.com>
In-Reply-To: <1490911959-5146-1-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Subject: [RFC 7/8] p2pmem: Support device removal
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

This patch creates a list of callbacks to notify users of this memory
that the p2pmem device is going away or gone.

In nvmet-rdma, we disconnect any queue using p2p memory.
The remote side will then automatically reconnect in a
couple seconds and regular system memory (or a different p2pmem device)
will be used.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/memory/p2pmem.c    | 75 ++++++++++++++++++++++++++++++++---
 drivers/nvme/target/rdma.c | 98 ++++++++++++++++++++++++++--------------------
 include/linux/p2pmem.h     | 19 +++++++--
 3 files changed, 140 insertions(+), 52 deletions(-)

diff --git a/drivers/memory/p2pmem.c b/drivers/memory/p2pmem.c
index 71741c2..499d42c 100644
--- a/drivers/memory/p2pmem.c
+++ b/drivers/memory/p2pmem.c
@@ -105,6 +105,21 @@ static void p2pmem_release(struct device *dev)
 	kfree(p);
 }
 
+struct remove_callback {
+	struct list_head list;
+	void (*callback)(void *context);
+	void *context;
+};
+
+static void p2pmem_remove(struct p2pmem_dev *p)
+{
+	struct remove_callback *remove_call, *tmp;
+
+	p->alive = false;
+	list_for_each_entry_safe(remove_call, tmp, &p->remove_list, list)
+		remove_call->callback(remove_call->context);
+}
+
 /**
  * p2pmem_create() - create a new p2pmem device
  * @parent: the parent device to create it under
@@ -123,6 +138,10 @@ struct p2pmem_dev *p2pmem_create(struct device *parent)
 		return ERR_PTR(-ENOMEM);
 
 	init_completion(&p->cmp);
+	mutex_init(&p->remove_mutex);
+	INIT_LIST_HEAD(&p->remove_list);
+	p->alive = true;
+
 	device_initialize(&p->dev);
 	p->dev.class = p2pmem_class;
 	p->dev.parent = parent;
@@ -187,6 +206,7 @@ void p2pmem_unregister(struct p2pmem_dev *p)
 
 	dev_info(&p->dev, "unregistered");
 	device_del(&p->dev);
+	p2pmem_remove(p);
 	ida_simple_remove(&p2pmem_ida, p->id);
 	put_device(&p->dev);
 }
@@ -291,6 +311,9 @@ EXPORT_SYMBOL(p2pmem_add_pci_region);
  */
 void *p2pmem_alloc(struct p2pmem_dev *p, size_t size)
 {
+	if (!p->alive)
+		return NULL;
+
 	return (void *)gen_pool_alloc(p->pool, size);
 }
 EXPORT_SYMBOL(p2pmem_alloc);
@@ -349,6 +372,9 @@ static int upstream_bridges_match(struct device *p2pmem,
 	struct pci_dev *p2p_up;
 	struct pci_dev *dma_up;
 
+	if (!to_p2pmem(p2pmem)->alive)
+		return false;
+
 	p2p_up = get_upstream_switch_port(p2pmem);
 	if (!p2p_up) {
 		dev_warn(p2pmem, "p2pmem is not behind a pci switch");
@@ -383,6 +409,8 @@ static int upstream_bridges_match(struct device *p2pmem,
  *	specified devices
  * @dma_devices: a null terminated array of device pointers which
  *	all must be compatible with the returned p2pmem device
+ * @remove_callback: this callback will be called if the p2pmem
+ *	device is removed.
  *
  * For now, we only support cases where all the devices that
  * will transfer to the p2pmem device are on the same switch.
@@ -400,9 +428,13 @@ static int upstream_bridges_match(struct device *p2pmem,
  * (use p2pmem_put to return the reference) or NULL if no compatible
  * p2pmem device is found.
  */
-struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devices)
+struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devices,
+				      void (*remove_callback)(void *context),
+				      void *context)
 {
 	struct device *dev;
+	struct p2pmem_dev *p;
+	struct remove_callback *remove_call;
 
 	dev = class_find_device(p2pmem_class, NULL, dma_devices,
 				upstream_bridges_match);
@@ -410,21 +442,54 @@ struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devices)
 	if (!dev)
 		return NULL;
 
-	return to_p2pmem(dev);
+	p = to_p2pmem(dev);
+	mutex_lock(&p->remove_mutex);
+
+	if (!p->alive) {
+		p = NULL;
+		goto out;
+	}
+
+	remove_call = kzalloc(sizeof(*remove_call), GFP_KERNEL);
+	remove_call->callback = remove_callback;
+	remove_call->context = context;
+	INIT_LIST_HEAD(&remove_call->list);
+	list_add(&remove_call->list, &p->remove_list);
+
+out:
+	mutex_unlock(&p->remove_mutex);
+	return p;
 }
 EXPORT_SYMBOL(p2pmem_find_compat);
 
 /**
  * p2pmem_put() - decrement a p2pmem device reference
  * @p: p2pmem device to return
+ * @data: data pointer that was passed to p2pmem_find_compat
  *
  * Dereference and free (if last) the device's reference counter.
  * It's safe to pass a NULL pointer to this function.
  */
-void p2pmem_put(struct p2pmem_dev *p)
+void p2pmem_put(struct p2pmem_dev *p, void *context)
 {
-	if (p)
-		put_device(&p->dev);
+	struct remove_callback *remove_call;
+
+	if (!p)
+		return;
+
+	mutex_lock(&p->remove_mutex);
+
+	list_for_each_entry(remove_call, &p->remove_list, list) {
+		if (remove_call->context != context)
+			continue;
+
+		list_del(&remove_call->list);
+		kfree(remove_call);
+		break;
+	}
+
+	mutex_unlock(&p->remove_mutex);
+	put_device(&p->dev);
 }
 EXPORT_SYMBOL(p2pmem_put);
 
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index abab544..9ebcda6 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1008,7 +1008,7 @@ static void nvmet_rdma_free_queue(struct nvmet_rdma_queue *queue)
 				!queue->host_qid);
 	}
 	nvmet_rdma_free_rsps(queue);
-	p2pmem_put(queue->p2pmem);
+	p2pmem_put(queue->p2pmem, queue);
 	ida_simple_remove(&nvmet_rdma_queue_ida, queue->idx);
 	kfree(queue);
 }
@@ -1204,6 +1204,58 @@ static int nvmet_rdma_cm_accept(struct rdma_cm_id *cm_id,
 	return ret;
 }
 
+static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
+{
+	bool disconnect = false;
+	unsigned long flags;
+
+	pr_debug("cm_id= %p queue->state= %d\n", queue->cm_id, queue->state);
+
+	spin_lock_irqsave(&queue->state_lock, flags);
+	switch (queue->state) {
+	case NVMET_RDMA_Q_CONNECTING:
+	case NVMET_RDMA_Q_LIVE:
+		queue->state = NVMET_RDMA_Q_DISCONNECTING;
+	case NVMET_RDMA_IN_DEVICE_REMOVAL:
+		disconnect = true;
+		break;
+	case NVMET_RDMA_Q_DISCONNECTING:
+		break;
+	}
+	spin_unlock_irqrestore(&queue->state_lock, flags);
+
+	if (disconnect) {
+		rdma_disconnect(queue->cm_id);
+		schedule_work(&queue->release_work);
+	}
+}
+
+static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
+{
+	bool disconnect = false;
+
+	mutex_lock(&nvmet_rdma_queue_mutex);
+	if (!list_empty(&queue->queue_list)) {
+		list_del_init(&queue->queue_list);
+		disconnect = true;
+	}
+	mutex_unlock(&nvmet_rdma_queue_mutex);
+
+	if (disconnect)
+		__nvmet_rdma_queue_disconnect(queue);
+}
+
+static void nvmet_rdma_p2pmem_remove(void *context)
+{
+	struct nvmet_rdma_queue *queue = context;
+
+	if (!queue->p2pmem)
+		return;
+
+	nvmet_rdma_queue_disconnect(queue);
+	flush_scheduled_work();
+}
+
 /*
  * If allow_p2pmem is set, we will try to use P2P memory for our
  * sgl lists. This requires the p2pmem device to be compatible with
@@ -1241,7 +1293,8 @@ static void nvmet_rdma_queue_setup_p2pmem(struct nvmet_rdma_queue *queue)
 
 	dma_devs[i++] = NULL;
 
-	queue->p2pmem = p2pmem_find_compat(dma_devs);
+	queue->p2pmem = p2pmem_find_compat(dma_devs, nvmet_rdma_p2pmem_remove,
+					   queue);
 
 	if (queue->p2pmem)
 		pr_debug("using %s for rdma nvme target queue",
@@ -1317,47 +1370,6 @@ static void nvmet_rdma_queue_established(struct nvmet_rdma_queue *queue)
 	spin_unlock_irqrestore(&queue->state_lock, flags);
 }
 
-static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
-{
-	bool disconnect = false;
-	unsigned long flags;
-
-	pr_debug("cm_id= %p queue->state= %d\n", queue->cm_id, queue->state);
-
-	spin_lock_irqsave(&queue->state_lock, flags);
-	switch (queue->state) {
-	case NVMET_RDMA_Q_CONNECTING:
-	case NVMET_RDMA_Q_LIVE:
-		queue->state = NVMET_RDMA_Q_DISCONNECTING;
-	case NVMET_RDMA_IN_DEVICE_REMOVAL:
-		disconnect = true;
-		break;
-	case NVMET_RDMA_Q_DISCONNECTING:
-		break;
-	}
-	spin_unlock_irqrestore(&queue->state_lock, flags);
-
-	if (disconnect) {
-		rdma_disconnect(queue->cm_id);
-		schedule_work(&queue->release_work);
-	}
-}
-
-static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
-{
-	bool disconnect = false;
-
-	mutex_lock(&nvmet_rdma_queue_mutex);
-	if (!list_empty(&queue->queue_list)) {
-		list_del_init(&queue->queue_list);
-		disconnect = true;
-	}
-	mutex_unlock(&nvmet_rdma_queue_mutex);
-
-	if (disconnect)
-		__nvmet_rdma_queue_disconnect(queue);
-}
-
 static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
 		struct nvmet_rdma_queue *queue)
 {
diff --git a/include/linux/p2pmem.h b/include/linux/p2pmem.h
index 4cd6f35..9365b02 100644
--- a/include/linux/p2pmem.h
+++ b/include/linux/p2pmem.h
@@ -22,12 +22,16 @@
 struct p2pmem_dev {
 	struct device dev;
 	int id;
+	bool alive;
 
 	struct percpu_ref ref;
 	struct completion cmp;
 	struct gen_pool *pool;
 
 	struct dentry *debugfs_root;
+
+	struct mutex remove_mutex;	/* protects the remove callback list */
+	struct list_head remove_list;
 };
 
 #ifdef CONFIG_P2PMEM
@@ -41,8 +45,12 @@ int p2pmem_add_pci_region(struct p2pmem_dev *p, struct pci_dev *pdev, int bar);
 void *p2pmem_alloc(struct p2pmem_dev *p, size_t size);
 void p2pmem_free(struct p2pmem_dev *p, void *addr, size_t size);
 
-struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devices);
-void p2pmem_put(struct p2pmem_dev *p);
+struct p2pmem_dev *
+p2pmem_find_compat(struct device **dma_devices,
+		   void (*unregister_callback)(void *context),
+		   void *context);
+
+void p2pmem_put(struct p2pmem_dev *p, void *context);
 
 #else
 
@@ -76,12 +84,15 @@ static inline void p2pmem_free(struct p2pmem_dev *p, void *addr, size_t size)
 {
 }
 
-static inline struct p2pmem_dev *p2pmem_find_compat(struct device **dma_devs)
+static inline struct p2pmem_dev *
+p2pmem_find_compat(struct device **dma_devices,
+		   void (*unregister_callback)(void *context),
+		   void *context)
 {
 	return NULL;
 }
 
-static inline void p2pmem_put(struct p2pmem_dev *p)
+static inline void p2pmem_put(struct p2pmem_dev *p, void *context)
 {
 }
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
