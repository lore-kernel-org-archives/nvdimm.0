Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF24321A0480E
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 15:13:45 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Mar 2017 16:12:34 -0600
Message-Id: <1490911959-5146-4-git-send-email-logang@deltatee.com>
In-Reply-To: <1490911959-5146-1-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Subject: [RFC 3/8] nvmet: Use p2pmem in nvme target
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

We create a configfs attribute in each nvme-fabrics target port to
enable p2p memory use. When enabled, the port will only then use the
p2p memory if a p2p memory device can be found which is behind the
same switch as the RDMA port and all the block devices in use. If
the user enabled it an no devices are found, then the system will
silently fall back on using regular memory.

If appropriate, that port will allocate memory for the RDMA buffers
for queues from the p2pmem device falling back to system memory should
anything fail.

Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
save an extra PCI transfer as the NVME card could just take the data
out of it's own memory. However, at this time, cards with CMB buffers
don't seem to be available.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/nvme/target/configfs.c | 31 +++++++++++++++
 drivers/nvme/target/nvmet.h    |  1 +
 drivers/nvme/target/rdma.c     | 90 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 114 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index be8c800..e61a7f4 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -777,12 +777,43 @@ static void nvmet_port_release(struct config_item *item)
 	kfree(port);
 }
 
+#ifdef CONFIG_P2PMEM
+static ssize_t nvmet_allow_p2pmem_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "%d\n", to_nvmet_port(item)->allow_p2pmem);
+}
+
+static ssize_t nvmet_allow_p2pmem_store(struct config_item *item,
+					const char *page, size_t count)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+	bool allow;
+	int ret;
+
+	ret = strtobool(page, &allow);
+	if (ret)
+		return ret;
+
+	down_write(&nvmet_config_sem);
+	port->allow_p2pmem = allow;
+	up_write(&nvmet_config_sem);
+
+	return count;
+}
+CONFIGFS_ATTR(nvmet_, allow_p2pmem);
+#endif
+
 static struct configfs_attribute *nvmet_port_attrs[] = {
 	&nvmet_attr_addr_adrfam,
 	&nvmet_attr_addr_treq,
 	&nvmet_attr_addr_traddr,
 	&nvmet_attr_addr_trsvcid,
 	&nvmet_attr_addr_trtype,
+
+	#ifdef CONFIG_P2PMEM
+	&nvmet_attr_allow_p2pmem,
+	#endif
+
 	NULL,
 };
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index f7ff15f..ab67175 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -95,6 +95,7 @@ struct nvmet_port {
 	struct list_head		referrals;
 	void				*priv;
 	bool				enabled;
+	bool				allow_p2pmem;
 };
 
 static inline struct nvmet_port *to_nvmet_port(struct config_item *item)
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index ecc4fe8..7fd4840 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -23,6 +23,7 @@
 #include <linux/string.h>
 #include <linux/wait.h>
 #include <linux/inet.h>
+#include <linux/p2pmem.h>
 #include <asm/unaligned.h>
 
 #include <rdma/ib_verbs.h>
@@ -64,6 +65,7 @@ struct nvmet_rdma_rsp {
 	struct rdma_rw_ctx	rw;
 
 	struct nvmet_req	req;
+	struct p2pmem_dev       *p2pmem;
 
 	u8			n_rdma;
 	u32			flags;
@@ -107,6 +109,8 @@ struct nvmet_rdma_queue {
 	int			send_queue_size;
 
 	struct list_head	queue_list;
+
+	struct p2pmem_dev	*p2pmem;
 };
 
 struct nvmet_rdma_device {
@@ -185,7 +189,8 @@ nvmet_rdma_put_rsp(struct nvmet_rdma_rsp *rsp)
 	spin_unlock_irqrestore(&rsp->queue->rsps_lock, flags);
 }
 
-static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents)
+static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents,
+				struct p2pmem_dev *p2pmem)
 {
 	struct scatterlist *sg;
 	int count;
@@ -193,13 +198,17 @@ static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents)
 	if (!sgl || !nents)
 		return;
 
-	for_each_sg(sgl, sg, nents, count)
-		__free_page(sg_page(sg));
+	for_each_sg(sgl, sg, nents, count) {
+		if (p2pmem)
+			p2pmem_free_page(p2pmem, sg_page(sg));
+		else
+			__free_page(sg_page(sg));
+	}
 	kfree(sgl);
 }
 
 static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
-		u32 length)
+		u32 length, struct p2pmem_dev *p2pmem)
 {
 	struct scatterlist *sg;
 	struct page *page;
@@ -216,7 +225,11 @@ static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
 	while (length) {
 		u32 page_len = min_t(u32, length, PAGE_SIZE);
 
-		page = alloc_page(GFP_KERNEL);
+		if (p2pmem)
+			page = p2pmem_alloc_page(p2pmem);
+		else
+			page = alloc_page(GFP_KERNEL);
+
 		if (!page)
 			goto out_free_pages;
 
@@ -231,7 +244,10 @@ static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
 out_free_pages:
 	while (i > 0) {
 		i--;
-		__free_page(sg_page(&sg[i]));
+		if (p2pmem)
+			p2pmem_free_page(p2pmem, sg_page(&sg[i]));
+		else
+			__free_page(sg_page(&sg[i]));
 	}
 	kfree(sg);
 out:
@@ -484,7 +500,8 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 	}
 
 	if (rsp->req.sg != &rsp->cmd->inline_sg)
-		nvmet_rdma_free_sgl(rsp->req.sg, rsp->req.sg_cnt);
+		nvmet_rdma_free_sgl(rsp->req.sg, rsp->req.sg_cnt,
+				    rsp->p2pmem);
 
 	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
 		nvmet_rdma_process_wr_wait_list(queue);
@@ -625,8 +642,16 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 	if (!len)
 		return 0;
 
+	rsp->p2pmem = rsp->queue->p2pmem;
 	status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
-			len);
+			len, rsp->p2pmem);
+
+	if (status && rsp->p2pmem) {
+		rsp->p2pmem = NULL;
+		status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
+					      len, rsp->p2pmem);
+	}
+
 	if (status)
 		return status;
 
@@ -984,6 +1009,7 @@ static void nvmet_rdma_free_queue(struct nvmet_rdma_queue *queue)
 				!queue->host_qid);
 	}
 	nvmet_rdma_free_rsps(queue);
+	p2pmem_put(queue->p2pmem);
 	ida_simple_remove(&nvmet_rdma_queue_ida, queue->idx);
 	kfree(queue);
 }
@@ -1179,6 +1205,52 @@ static int nvmet_rdma_cm_accept(struct rdma_cm_id *cm_id,
 	return ret;
 }
 
+/*
+ * If allow_p2pmem is set, we will try to use P2P memory for our
+ * sgl lists. This requires the p2pmem device to be compatible with
+ * the backing device for every namespace this device will support.
+ * If not, we fall back on using system memory.
+ */
+static void nvmet_rdma_queue_setup_p2pmem(struct nvmet_rdma_queue *queue)
+{
+	struct device **dma_devs;
+	struct nvmet_ns *ns;
+	int ndevs = 1;
+	int i = 0;
+	struct nvmet_subsys_link *s;
+
+	if (!queue->port->allow_p2pmem)
+		return;
+
+	list_for_each_entry(s, &queue->port->subsystems, entry) {
+		list_for_each_entry_rcu(ns, &s->subsys->namespaces, dev_link) {
+			ndevs++;
+		}
+	}
+
+	dma_devs = kmalloc((ndevs + 1) * sizeof(*dma_devs), GFP_KERNEL);
+	if (!dma_devs)
+		return;
+
+	dma_devs[i++] = &queue->dev->device->dev;
+
+	list_for_each_entry(s, &queue->port->subsystems, entry) {
+		list_for_each_entry_rcu(ns, &s->subsys->namespaces, dev_link) {
+			dma_devs[i++] = disk_to_dev(ns->bdev->bd_disk);
+		}
+	}
+
+	dma_devs[i++] = NULL;
+
+	queue->p2pmem = p2pmem_find_compat(dma_devs);
+
+	if (queue->p2pmem)
+		pr_debug("using %s for rdma nvme target queue",
+			 dev_name(&queue->p2pmem->dev));
+
+	kfree(dma_devs);
+}
+
 static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 		struct rdma_cm_event *event)
 {
@@ -1199,6 +1271,8 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 	}
 	queue->port = cm_id->context;
 
+	nvmet_rdma_queue_setup_p2pmem(queue);
+
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
 	if (ret)
 		goto release_queue;
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
