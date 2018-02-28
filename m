Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E074922402E0F
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 15:34:13 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 28 Feb 2018 16:40:01 -0700
Message-Id: <20180228234006.21093-6-logang@deltatee.com>
In-Reply-To: <20180228234006.21093-1-logang@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
Subject: [PATCH v2 05/10] block: Introduce PCI P2P flags for request and
 request queue
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

QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
supports targeting P2P memory.

REQ_PCI_P2P is introduced to indicate a particular bio request is
directed to/from PCI P2P memory. A request with this flag is not
accepted unless the corresponding queues have the QUEUE_FLAG_PCI_P2P
flag set.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-core.c          |  3 +++
 include/linux/blk_types.h | 18 +++++++++++++++++-
 include/linux/blkdev.h    |  3 +++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2d1a7bbe0634..36a6a304a559 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2183,6 +2183,9 @@ generic_make_request_checks(struct bio *bio)
 	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q))
 		goto not_supported;
 
+	if ((bio->bi_opf & REQ_PCI_P2PDMA) && !blk_queue_pci_p2pdma(q))
+		goto not_supported;
+
 	if (should_fail_bio(bio))
 		goto end_io;
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index bf18b95ed92d..490122c85b3f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -274,6 +274,10 @@ enum req_flag_bits {
 	__REQ_BACKGROUND,	/* background IO */
 	__REQ_NOWAIT,           /* Don't wait if request will block */
 
+#ifdef CONFIG_PCI_P2PDMA
+	__REQ_PCI_P2PDMA,	/* request is to/from P2P memory */
+#endif
+
 	/* command specific flags for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
@@ -298,6 +302,18 @@ enum req_flag_bits {
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 
+#ifdef CONFIG_PCI_P2PDMA
+/*
+ * Currently SGLs do not support mixed P2P and regular memory so
+ * requests with P2P memory must not be merged.
+ */
+#define REQ_PCI_P2PDMA		(1ULL << __REQ_PCI_P2PDMA)
+#define REQ_IS_PCI_P2PDMA(req)	((req)->cmd_flags & REQ_PCI_P2PDMA)
+#else
+#define REQ_PCI_P2PDMA		0
+#define REQ_IS_PCI_P2PDMA(req)	0
+#endif /* CONFIG_PCI_P2PDMA */
+
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
@@ -306,7 +322,7 @@ enum req_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 
 #define REQ_NOMERGE_FLAGS \
-	(REQ_NOMERGE | REQ_PREFLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_PREFLUSH | REQ_FUA | REQ_PCI_P2PDMA)
 
 #define bio_op(bio) \
 	((bio)->bi_opf & REQ_OP_MASK)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ed63f3b69c12..0b4a386c73ea 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -698,6 +698,7 @@ struct request_queue {
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
 #define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
+#define QUEUE_FLAG_PCI_P2PDMA  30	/* device supports pci p2p requests */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
@@ -793,6 +794,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
 #define blk_queue_scsi_passthrough(q)	\
 	test_bit(QUEUE_FLAG_SCSI_PASSTHROUGH, &(q)->queue_flags)
+#define blk_queue_pci_p2pdma(q)	\
+	test_bit(QUEUE_FLAG_PCI_P2PDMA, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
