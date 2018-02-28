Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAF8121FD73D0
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 15:34:12 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 28 Feb 2018 16:40:02 -0700
Message-Id: <20180228234006.21093-7-logang@deltatee.com>
In-Reply-To: <20180228234006.21093-1-logang@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
Subject: [PATCH v2 06/10] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
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
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

In order to use PCI P2P memory pci_p2pmem_[un]map_sg() functions must be
called to map the correct DMA address. To do this, we add a flags
variable and the RDMA_RW_CTX_FLAG_PCI_P2P flag. When the flag is
specified use the appropriate map function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/infiniband/core/rw.c            | 21 +++++++++++++++++----
 drivers/infiniband/ulp/isert/ib_isert.c |  5 +++--
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  7 ++++---
 drivers/nvme/target/rdma.c              |  6 +++---
 include/rdma/rw.h                       |  7 +++++--
 net/sunrpc/xprtrdma/svc_rdma_rw.c       |  6 +++---
 6 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index c8963e91f92a..775a9f8b15a6 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -12,6 +12,7 @@
  */
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/pci-p2pdma.h>
 #include <rdma/mr_pool.h>
 #include <rdma/rw.h>
 
@@ -269,18 +270,24 @@ static int rdma_rw_init_single_wr(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
  * @remote_addr:remote address to read/write (relative to @rkey)
  * @rkey:	remote key to operate on
  * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ * @flags:      any of the RDMA_RW_CTX_FLAG_* flags
  *
  * Returns the number of WQEs that will be needed on the workqueue if
  * successful, or a negative error code.
  */
 int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
-		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
+		unsigned int flags)
 {
 	struct ib_device *dev = qp->pd->device;
 	int ret;
 
-	ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
+	if (flags & RDMA_RW_CTX_FLAG_PCI_P2PDMA)
+		ret = pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
+	else
+		ret = ib_dma_map_sg(dev, sg, sg_cnt, dir);
+
 	if (!ret)
 		return -ENOMEM;
 	sg_cnt = ret;
@@ -579,9 +586,11 @@ EXPORT_SYMBOL(rdma_rw_ctx_post);
  * @sg:		scatterlist that was used for the READ/WRITE
  * @sg_cnt:	number of entries in @sg
  * @dir:	%DMA_TO_DEVICE for RDMA WRITE, %DMA_FROM_DEVICE for RDMA READ
+ * @flags:      the same flags used to init the context
  */
 void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
-		struct scatterlist *sg, u32 sg_cnt, enum dma_data_direction dir)
+		struct scatterlist *sg, u32 sg_cnt, enum dma_data_direction dir,
+		unsigned int flags)
 {
 	int i;
 
@@ -602,7 +611,11 @@ void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		break;
 	}
 
-	ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
+	if (flags & RDMA_RW_CTX_FLAG_PCI_P2PDMA)
+		pci_p2pdma_unmap_sg(qp->pd->device->dma_device, sg,
+				    sg_cnt, dir);
+	else
+		ib_dma_unmap_sg(qp->pd->device, sg, sg_cnt, dir);
 }
 EXPORT_SYMBOL(rdma_rw_ctx_destroy);
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index fff40b097947..933200645262 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1497,7 +1497,8 @@ isert_rdma_rw_ctx_destroy(struct isert_cmd *cmd, struct isert_conn *conn)
 				se_cmd->t_prot_nents, dir);
 	} else {
 		rdma_rw_ctx_destroy(&cmd->rw, conn->qp, conn->cm_id->port_num,
-				se_cmd->t_data_sg, se_cmd->t_data_nents, dir);
+				se_cmd->t_data_sg, se_cmd->t_data_nents,
+				dir, 0);
 	}
 
 	cmd->rw.nr_ops = 0;
@@ -2152,7 +2153,7 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
 	} else {
 		ret = rdma_rw_ctx_init(&cmd->rw, conn->qp, port_num,
 				se_cmd->t_data_sg, se_cmd->t_data_nents,
-				offset, addr, rkey, dir);
+				offset, addr, rkey, dir, 0);
 	}
 
 	if (ret < 0) {
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0373b7c40902..5dcbe0a18db8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -899,7 +899,8 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 			goto unwind;
 
 		ret = rdma_rw_ctx_init(&ctx->rw, ch->qp, ch->sport->port,
-				ctx->sg, ctx->nents, 0, remote_addr, rkey, dir);
+				ctx->sg, ctx->nents, 0, remote_addr, rkey,
+				dir, 0);
 		if (ret < 0) {
 			target_free_sgl(ctx->sg, ctx->nents);
 			goto unwind;
@@ -928,7 +929,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 
 		rdma_rw_ctx_destroy(&ctx->rw, ch->qp, ch->sport->port,
-				ctx->sg, ctx->nents, dir);
+				ctx->sg, ctx->nents, dir, 0);
 		target_free_sgl(ctx->sg, ctx->nents);
 	}
 	if (ioctx->rw_ctxs != &ioctx->s_rw_ctx)
@@ -946,7 +947,7 @@ static void srpt_free_rw_ctxs(struct srpt_rdma_ch *ch,
 		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 
 		rdma_rw_ctx_destroy(&ctx->rw, ch->qp, ch->sport->port,
-				ctx->sg, ctx->nents, dir);
+				ctx->sg, ctx->nents, dir, 0);
 		target_free_sgl(ctx->sg, ctx->nents);
 	}
 
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 978e169c11bf..020354e11351 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -427,7 +427,7 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
 	if (rsp->n_rdma) {
 		rdma_rw_ctx_destroy(&rsp->rw, queue->cm_id->qp,
 				queue->cm_id->port_num, rsp->req.sg,
-				rsp->req.sg_cnt, nvmet_data_dir(&rsp->req));
+				rsp->req.sg_cnt, nvmet_data_dir(&rsp->req), 0);
 	}
 
 	if (rsp->req.sg != &rsp->cmd->inline_sg)
@@ -510,7 +510,7 @@ static void nvmet_rdma_read_data_done(struct ib_cq *cq, struct ib_wc *wc)
 	atomic_add(rsp->n_rdma, &queue->sq_wr_avail);
 	rdma_rw_ctx_destroy(&rsp->rw, queue->cm_id->qp,
 			queue->cm_id->port_num, rsp->req.sg,
-			rsp->req.sg_cnt, nvmet_data_dir(&rsp->req));
+			rsp->req.sg_cnt, nvmet_data_dir(&rsp->req), 0);
 	rsp->n_rdma = 0;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
@@ -579,7 +579,7 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 
 	ret = rdma_rw_ctx_init(&rsp->rw, cm_id->qp, cm_id->port_num,
 			rsp->req.sg, rsp->req.sg_cnt, 0, addr, key,
-			nvmet_data_dir(&rsp->req));
+			nvmet_data_dir(&rsp->req), 0);
 	if (ret < 0)
 		return NVME_SC_INTERNAL;
 	rsp->req.transfer_len += len;
diff --git a/include/rdma/rw.h b/include/rdma/rw.h
index a3cbbc7b6417..dbc342b53901 100644
--- a/include/rdma/rw.h
+++ b/include/rdma/rw.h
@@ -59,12 +59,15 @@ struct rdma_rw_ctx {
 	};
 };
 
+#define RDMA_RW_CTX_FLAG_PCI_P2PDMA  (1 << 0)
+
 int rdma_rw_ctx_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt, u32 sg_offset,
-		u64 remote_addr, u32 rkey, enum dma_data_direction dir);
+		u64 remote_addr, u32 rkey, enum dma_data_direction dir,
+		unsigned int flags);
 void rdma_rw_ctx_destroy(struct rdma_rw_ctx *ctx, struct ib_qp *qp, u8 port_num,
 		struct scatterlist *sg, u32 sg_cnt,
-		enum dma_data_direction dir);
+		enum dma_data_direction dir, unsigned int flags);
 
 int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		u8 port_num, struct scatterlist *sg, u32 sg_cnt,
diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 12b9a7e0b6d2..4364a8e98470 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -140,7 +140,7 @@ static void svc_rdma_cc_release(struct svc_rdma_chunk_ctxt *cc,
 
 		rdma_rw_ctx_destroy(&ctxt->rw_ctx, rdma->sc_qp,
 				    rdma->sc_port_num, ctxt->rw_sg_table.sgl,
-				    ctxt->rw_nents, dir);
+				    ctxt->rw_nents, dir, 0);
 		svc_rdma_put_rw_ctxt(rdma, ctxt);
 	}
 	svc_xprt_put(&rdma->sc_xprt);
@@ -433,7 +433,7 @@ svc_rdma_build_writes(struct svc_rdma_write_info *info,
 		ret = rdma_rw_ctx_init(&ctxt->rw_ctx, rdma->sc_qp,
 				       rdma->sc_port_num, ctxt->rw_sg_table.sgl,
 				       ctxt->rw_nents, 0, seg_offset,
-				       seg_handle, DMA_TO_DEVICE);
+				       seg_handle, DMA_TO_DEVICE, 0);
 		if (ret < 0)
 			goto out_initerr;
 
@@ -639,7 +639,7 @@ static int svc_rdma_build_read_segment(struct svc_rdma_read_info *info,
 	ret = rdma_rw_ctx_init(&ctxt->rw_ctx, cc->cc_rdma->sc_qp,
 			       cc->cc_rdma->sc_port_num,
 			       ctxt->rw_sg_table.sgl, ctxt->rw_nents,
-			       0, offset, rkey, DMA_FROM_DEVICE);
+			       0, offset, rkey, DMA_FROM_DEVICE, 0);
 	if (ret < 0)
 		goto out_initerr;
 
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
