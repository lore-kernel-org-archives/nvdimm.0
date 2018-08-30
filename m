Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73CB62110747B
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 11:54:03 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Aug 2018 12:53:46 -0600
Message-Id: <20180830185352.3369-8-logang@deltatee.com>
In-Reply-To: <20180830185352.3369-1-logang@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
Subject: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and check
 support for requests
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
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
supports targeting P2P memory.

When a request is submitted we check if PCI P2PDMA memory is assigned
to the first page in the bio. If it is, we ensure the queue it's
submitted to supports it, and enforce REQ_NOMERGE.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-core.c       | 14 ++++++++++++++
 include/linux/blkdev.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index dee56c282efb..cc0289c7b983 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2264,6 +2264,20 @@ generic_make_request_checks(struct bio *bio)
 	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q))
 		goto not_supported;
 
+	/*
+	 * Ensure PCI P2PDMA memory is not used in requests to queues that
+	 * have no support. This should never happen if the higher layers using
+	 * P2PDMA do the right thing and use the proper P2PDMA client
+	 * infrastructure. Also, ensure such requests use REQ_NOMERGE
+	 * seeing requests can not mix P2PDMA and non-P2PDMA memory at
+	 * this time.
+	 */
+	if (bio->bi_vcnt && is_pci_p2pdma_page(bio->bi_io_vec->bv_page)) {
+		if (WARN_ON_ONCE(!blk_queue_pci_p2pdma(q)))
+			goto not_supported;
+		bio->bi_opf |= REQ_NOMERGE;
+	}
+
 	if (should_fail_bio(bio))
 		goto end_io;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d6869e0e2b64..7bf80ca802e1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -699,6 +699,7 @@ struct request_queue {
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
 #define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
+#define QUEUE_FLAG_PCI_P2PDMA  30	/* device supports pci p2p requests */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
@@ -731,6 +732,8 @@ bool blk_queue_flag_test_and_clear(unsigned int flag, struct request_queue *q);
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
