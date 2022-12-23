Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5EA23A0
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 06:55:44 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="101163258"
X-IronPort-AV: E=Sophos;i="5.96,267,1665414000"; 
   d="scan'208";a="101163258"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP; 23 Dec 2022 15:52:33 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0E504DE50D
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:31 +0900 (JST)
Received: from m3003.s.css.fujitsu.com (m3003.s.css.fujitsu.com [10.128.233.114])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 51445D35C7
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:30 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3003.s.css.fujitsu.com (Postfix) with ESMTP id 1AEBA200B2A8;
	Fri, 23 Dec 2022 15:52:30 +0900 (JST)
From: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
To: linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	jgg@nvidia.com,
	zyjzyj2000@gmail.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	rpearsonhpe@gmail.com,
	yangx.jy@fujitsu.com,
	lizhijian@fujitsu.com,
	y-goto@fujitsu.com,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Subject: [PATCH for-next v3 7/7] RDMA/rxe: Add support for the traditional Atomic operations with ODP
Date: Fri, 23 Dec 2022 15:51:58 +0900
Message-Id: <30553db1a0333a714ec60b560d54efdfbf07f24d.1671772917.git.matsuda-daisuke@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1671772917.git.matsuda-daisuke@fujitsu.com>
References: <cover.1671772917.git.matsuda-daisuke@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00

Enable 'fetch and add' and 'compare and swap' operations to manipulate
data in an ODP-enabled MR. This is comprised of the following steps:
 1. Check the driver page table(umem_odp->dma_list) to see if the target
    page is both readable and writable.
 2. If not, then trigger page fault to map the page.
 3. Convert its user space address to a kernel logical address using PFNs
    in the driver page table(umem_odp->pfn_list).
 4. Execute the operation.

umem_mutex is used to ensure that dma_list (an array of addresses of an MR)
is not changed while it is checked and that the target page is not
invalidated before data access completes.

Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
---
 drivers/infiniband/sw/rxe/rxe.c      |  1 +
 drivers/infiniband/sw/rxe/rxe_loc.h  | 11 +++++++
 drivers/infiniband/sw/rxe/rxe_odp.c  | 46 ++++++++++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_resp.c |  2 +-
 4 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 2c9f0cf96671..30daf14ee0e8 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -88,6 +88,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_RECV;
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_WRITE;
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_READ;
+		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_ATOMIC;
 		rxe->attr.odp_caps.per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
 	}
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index fb468999e81e..24b0b7069688 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -7,6 +7,8 @@
 #ifndef RXE_LOC_H
 #define RXE_LOC_H
 
+#include "rxe_resp.h"
+
 /* rxe_av.c */
 void rxe_init_av(struct rdma_ah_attr *attr, struct rxe_av *av);
 int rxe_av_chk_attr(struct rxe_qp *qp, struct rdma_ah_attr *attr);
@@ -192,6 +194,8 @@ int rxe_create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length, u64 iova,
 			   int access_flags, struct rxe_mr *mr);
 int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr, int length,
 		    enum rxe_mr_copy_dir dir);
+enum resp_states rxe_odp_atomic_ops(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
+				    struct rxe_mr *mr);
 
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 static inline int
@@ -204,6 +208,13 @@ static inline int
 rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 		int length, enum rxe_mr_copy_dir dir) { return 0; }
 
+static inline enum resp_states
+rxe_odp_atomic_ops(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
+		   struct rxe_mr *mr)
+{
+	return RESPST_ERR_UNSUPPORTED_OPCODE;
+}
+
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
 #endif /* RXE_LOC_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index c55512417d11..6e0b6a872ddc 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -291,3 +291,49 @@ int rxe_odp_mr_copy(struct rxe_mr *mr, u64 iova, void *addr, int length,
 
 	return err;
 }
+
+static inline void *rxe_odp_get_virt_atomic(struct rxe_qp *qp, struct rxe_mr *mr)
+{
+	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+	u64 iova = qp->resp.va + qp->resp.offset;
+	int idx;
+	size_t offset;
+
+	if (rxe_odp_map_range(mr, iova, sizeof(char), 0))
+		return NULL;
+
+	idx = (iova - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
+	offset = iova & (BIT(umem_odp->page_shift) - 1);
+
+	return rxe_odp_get_virt(umem_odp, idx, offset);
+}
+
+enum resp_states rxe_odp_atomic_ops(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
+				    struct rxe_mr *mr)
+{
+	struct ib_umem_odp *umem_odp = to_ib_umem_odp(mr->umem);
+	u64 *vaddr;
+	int ret;
+
+	if (unlikely(!mr->odp_enabled))
+		return RESPST_ERR_RKEY_VIOLATION;
+
+	/* If pagefault is not required, umem mutex will be held until the
+	 * atomic operation completes. Otherwise, it is released and locked
+	 * again in rxe_odp_map_range() to let invalidation handler do its
+	 * work meanwhile.
+	 */
+	mutex_lock(&umem_odp->umem_mutex);
+
+	vaddr = (u64 *)rxe_odp_get_virt_atomic(qp, mr);
+	if (!vaddr)
+		return RESPST_ERR_RKEY_VIOLATION;
+
+	if (pkt->mask & RXE_ATOMIC_MASK)
+		ret = rxe_process_atomic(qp, pkt, vaddr);
+	else
+		ret = RESPST_ERR_UNSUPPORTED_OPCODE;
+
+	mutex_unlock(&umem_odp->umem_mutex);
+	return ret;
+}
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 7ef492e50e20..669d3e1a6ee4 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -784,7 +784,7 @@ static enum resp_states rxe_atomic_reply(struct rxe_qp *qp,
 			return RESPST_ERR_RKEY_VIOLATION;
 
 		if (mr->odp_enabled)
-			ret = RESPST_ERR_UNSUPPORTED_OPCODE;
+			ret = rxe_odp_atomic_ops(qp, pkt, mr);
 		else
 			ret = rxe_atomic_ops(qp, pkt, mr);
 	} else
-- 
2.31.1

