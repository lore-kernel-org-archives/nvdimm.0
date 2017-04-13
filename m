Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACC5A21DFA7AF
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:20 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:16 -0600
Message-Id: <1492121135-4437-4-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 03/22] libiscsi: Make use of new the sg_map helper function
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
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

Convert the kmap and kmap_atomic uses to the sg_map function. We now
store the flags for the kmap instead of a boolean to indicate
atomicitiy. We also propogate a possible kmap error down and create
a new ISCSI_TCP_INTERNAL_ERR error type for this.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  5 +++++
 drivers/scsi/libiscsi_tcp.c   | 32 ++++++++++++++++++++------------
 include/scsi/libiscsi_tcp.h   |  3 ++-
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39e..e38d0c1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1556,6 +1556,11 @@ static inline int read_pdu_skb(struct iscsi_conn *conn,
 		 */
 		iscsi_conn_printk(KERN_ERR, conn, "Invalid pdu or skb.");
 		return -EFAULT;
+	case ISCSI_TCP_INTERNAL_ERR:
+		pr_info("skb 0x%p, off %u, %d, TCP_INTERNAL_ERR.\n",
+			skb, offset, offloaded);
+		iscsi_conn_printk(KERN_ERR, conn, "Internal error.");
+		return -EFAULT;
 	case ISCSI_TCP_SEGMENT_DONE:
 		log_debug(1 << CXGBI_DBG_PDU_RX,
 			"skb 0x%p, off %u, %d, TCP_SEG_DONE, rc %d.\n",
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 63a1d69..a2427699 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -133,25 +133,23 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 	if (page_count(sg_page(sg)) >= 1 && !recv)
 		return;
 
-	if (recv) {
-		segment->atomic_mapped = true;
-		segment->sg_mapped = kmap_atomic(sg_page(sg));
-	} else {
-		segment->atomic_mapped = false;
-		/* the xmit path can sleep with the page mapped so use kmap */
-		segment->sg_mapped = kmap(sg_page(sg));
+	/* the xmit path can sleep with the page mapped so don't use atomic */
+	segment->sg_map_flags = recv ? SG_KMAP_ATOMIC : SG_KMAP;
+	segment->sg_mapped = sg_map(sg, segment->sg_map_flags);
+
+	if (IS_ERR(segment->sg_mapped)) {
+		segment->sg_mapped = NULL;
+		return;
 	}
 
-	segment->data = segment->sg_mapped + sg->offset + segment->sg_offset;
+	segment->data = segment->sg_mapped + segment->sg_offset;
 }
 
 void iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
 {
 	if (segment->sg_mapped) {
-		if (segment->atomic_mapped)
-			kunmap_atomic(segment->sg_mapped);
-		else
-			kunmap(sg_page(segment->sg));
+		sg_unmap(segment->sg, segment->sg_mapped,
+			  segment->sg_map_flags);
 		segment->sg_mapped = NULL;
 		segment->data = NULL;
 	}
@@ -304,6 +302,9 @@ iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
 			break;
 		}
 
+		if (segment->data)
+			return -EFAULT;
+
 		copy = min(len - copied, segment->size - segment->copied);
 		ISCSI_DBG_TCP(tcp_conn->iscsi_conn, "copying %d\n", copy);
 		memcpy(segment->data + segment->copied, ptr + copied, copy);
@@ -927,6 +928,13 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 			      avail);
 		rc = iscsi_tcp_segment_recv(tcp_conn, segment, ptr, avail);
 		BUG_ON(rc == 0);
+		if (rc < 0) {
+			ISCSI_DBG_TCP(conn, "memory fault. Consumed %d\n",
+				      consumed);
+			*status = ISCSI_TCP_INTERNAL_ERR;
+			goto skb_done;
+		}
+
 		consumed += rc;
 
 		if (segment->total_copied >= segment->total_size) {
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 30520d5..58c79af 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -47,7 +47,7 @@ struct iscsi_segment {
 	struct scatterlist	*sg;
 	void			*sg_mapped;
 	unsigned int		sg_offset;
-	bool			atomic_mapped;
+	int			sg_map_flags;
 
 	iscsi_segment_done_fn_t	*done;
 };
@@ -92,6 +92,7 @@ enum {
 	ISCSI_TCP_SKB_DONE,		/* skb is out of data */
 	ISCSI_TCP_CONN_ERR,		/* iscsi layer has fired a conn err */
 	ISCSI_TCP_SUSPENDED,		/* conn is suspended */
+	ISCSI_TCP_INTERNAL_ERR,         /* an internal error occurred */
 };
 
 extern void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn);
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
