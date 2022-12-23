Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF1C23A0
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 06:53:35 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="88943793"
X-IronPort-AV: E=Sophos;i="5.96,267,1665414000"; 
   d="scan'208";a="88943793"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP; 23 Dec 2022 15:52:23 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 87B82DF0A8
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:22 +0900 (JST)
Received: from m3003.s.css.fujitsu.com (m3003.s.css.fujitsu.com [10.128.233.114])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id AC425D6146
	for <nvdimm@lists.linux.dev>; Fri, 23 Dec 2022 15:52:21 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3003.s.css.fujitsu.com (Postfix) with ESMTP id 653E9203EF13;
	Fri, 23 Dec 2022 15:52:21 +0900 (JST)
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
Subject: [PATCH for-next v3 3/7] RDMA/rxe: Cleanup code for responder Atomic operations
Date: Fri, 23 Dec 2022 15:51:54 +0900
Message-Id: <d95bb1de314ec3cf5a93e0c5730900d67521e08d.1671772917.git.matsuda-daisuke@fujitsu.com>
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

Currently, rxe_responder() directly calls the function to execute Atomic
operations. This need to be modified to insert some conditional branches
for the ODP feature. Additionally, rxe_resp.h is newly added to be used by
rxe_odp.c in near future.

Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 100 +++++++++++++++++----------
 drivers/infiniband/sw/rxe/rxe_resp.h |   9 +++
 2 files changed, 71 insertions(+), 38 deletions(-)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_resp.h

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 991550baef8c..e18bca076337 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -9,6 +9,7 @@
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_queue.h"
+#include "rxe_resp.h"
 
 enum resp_states {
 	RESPST_NONE,
@@ -733,60 +734,83 @@ static enum resp_states process_flush(struct rxe_qp *qp,
 /* Guarantee atomicity of atomic operations at the machine level. */
 static DEFINE_SPINLOCK(atomic_ops_lock);
 
-static enum resp_states atomic_reply(struct rxe_qp *qp,
-					 struct rxe_pkt_info *pkt)
+enum resp_states rxe_process_atomic(struct rxe_qp *qp,
+				    struct rxe_pkt_info *pkt, u64 *vaddr)
 {
-	u64 *vaddr;
 	enum resp_states ret;
-	struct rxe_mr *mr = qp->resp.mr;
 	struct resp_res *res = qp->resp.res;
 	u64 value;
 
-	if (!res) {
-		res = rxe_prepare_res(qp, pkt, RXE_ATOMIC_MASK);
-		qp->resp.res = res;
+	/* check vaddr is 8 bytes aligned. */
+	if (!vaddr || (uintptr_t)vaddr & 7) {
+		ret = RESPST_ERR_MISALIGNED_ATOMIC;
+		goto out;
 	}
 
-	if (!res->replay) {
-		if (mr->state != RXE_MR_STATE_VALID) {
-			ret = RESPST_ERR_RKEY_VIOLATION;
-			goto out;
-		}
+	spin_lock(&atomic_ops_lock);
+	res->atomic.orig_val = value = *vaddr;
 
-		vaddr = iova_to_vaddr(mr, qp->resp.va + qp->resp.offset,
-					sizeof(u64));
+	if (pkt->opcode == IB_OPCODE_RC_COMPARE_SWAP) {
+		if (value == atmeth_comp(pkt))
+			value = atmeth_swap_add(pkt);
+	} else {
+		value += atmeth_swap_add(pkt);
+	}
 
-		/* check vaddr is 8 bytes aligned. */
-		if (!vaddr || (uintptr_t)vaddr & 7) {
-			ret = RESPST_ERR_MISALIGNED_ATOMIC;
-			goto out;
-		}
+	*vaddr = value;
+	spin_unlock(&atomic_ops_lock);
 
-		spin_lock_bh(&atomic_ops_lock);
-		res->atomic.orig_val = value = *vaddr;
+	qp->resp.msn++;
 
-		if (pkt->opcode == IB_OPCODE_RC_COMPARE_SWAP) {
-			if (value == atmeth_comp(pkt))
-				value = atmeth_swap_add(pkt);
-		} else {
-			value += atmeth_swap_add(pkt);
-		}
+	/* next expected psn, read handles this separately */
+	qp->resp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
+	qp->resp.ack_psn = qp->resp.psn;
 
-		*vaddr = value;
-		spin_unlock_bh(&atomic_ops_lock);
+	qp->resp.opcode = pkt->opcode;
+	qp->resp.status = IB_WC_SUCCESS;
 
-		qp->resp.msn++;
+	ret = RESPST_ACKNOWLEDGE;
+out:
+	return ret;
+}
+
+static enum resp_states rxe_atomic_ops(struct rxe_qp *qp,
+					struct rxe_pkt_info *pkt,
+					struct rxe_mr *mr)
+{
+	u64 *vaddr;
+	int ret;
+
+	vaddr = iova_to_vaddr(mr, qp->resp.va + qp->resp.offset,
+			      sizeof(u64));
+
+	if (pkt->mask & RXE_ATOMIC_MASK)
+		ret = rxe_process_atomic(qp, pkt, vaddr);
+	else
+		ret = RESPST_ERR_UNSUPPORTED_OPCODE;
+
+	return ret;
+}
 
-		/* next expected psn, read handles this separately */
-		qp->resp.psn = (pkt->psn + 1) & BTH_PSN_MASK;
-		qp->resp.ack_psn = qp->resp.psn;
+static enum resp_states rxe_atomic_reply(struct rxe_qp *qp,
+					 struct rxe_pkt_info *pkt)
+{
+	struct rxe_mr *mr = qp->resp.mr;
+	struct resp_res *res = qp->resp.res;
+	int ret;
 
-		qp->resp.opcode = pkt->opcode;
-		qp->resp.status = IB_WC_SUCCESS;
+	if (!res) {
+		res = rxe_prepare_res(qp, pkt, RXE_ATOMIC_MASK);
+		qp->resp.res = res;
 	}
 
-	ret = RESPST_ACKNOWLEDGE;
-out:
+	if (!res->replay) {
+		if (mr->state != RXE_MR_STATE_VALID)
+			return RESPST_ERR_RKEY_VIOLATION;
+		ret = rxe_atomic_ops(qp, pkt, mr);
+	} else
+		ret = RESPST_ACKNOWLEDGE;
+
 	return ret;
 }
 
@@ -1556,7 +1580,7 @@ int rxe_responder(void *arg)
 			state = read_reply(qp, pkt);
 			break;
 		case RESPST_ATOMIC_REPLY:
-			state = atomic_reply(qp, pkt);
+			state = rxe_atomic_reply(qp, pkt);
 			break;
 		case RESPST_ATOMIC_WRITE_REPLY:
 			state = atomic_write_reply(qp, pkt);
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.h b/drivers/infiniband/sw/rxe/rxe_resp.h
new file mode 100644
index 000000000000..94a4869fdab6
--- /dev/null
+++ b/drivers/infiniband/sw/rxe/rxe_resp.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+
+#ifndef RXE_RESP_H
+#define RXE_RESP_H
+
+enum resp_states rxe_process_atomic(struct rxe_qp *qp,
+				    struct rxe_pkt_info *pkt, u64 *vaddr);
+
+#endif /* RXE_RESP_H */
-- 
2.31.1

