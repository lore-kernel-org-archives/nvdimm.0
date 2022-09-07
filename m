Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CC97E
	for <nvdimm@lists.linux.dev>; Wed,  7 Sep 2022 02:45:31 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="87096006"
X-IronPort-AV: E=Sophos;i="5.93,295,1654527600"; 
   d="scan'208";a="87096006"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP; 07 Sep 2022 11:44:20 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 0483DD63B6
	for <nvdimm@lists.linux.dev>; Wed,  7 Sep 2022 11:44:19 +0900 (JST)
Received: from m3002.s.css.fujitsu.com (msm3.b.css.fujitsu.com [10.128.233.104])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3B414BF4AF
	for <nvdimm@lists.linux.dev>; Wed,  7 Sep 2022 11:44:18 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3002.s.css.fujitsu.com (Postfix) with ESMTP id EA7D3200B45F;
	Wed,  7 Sep 2022 11:44:17 +0900 (JST)
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
Subject: [RFC PATCH 1/7] IB/mlx5: Change ib_umem_odp_map_dma_single_page() to retain umem_mutex
Date: Wed,  7 Sep 2022 11:42:59 +0900
Message-Id: <33fae63a51729aa44470f2fbafe0d0d7ac90d58d.1662461897.git.matsuda-daisuke@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1662461897.git.matsuda-daisuke@fujitsu.com>
References: <cover.1662461897.git.matsuda-daisuke@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00

ib_umem_odp_map_dma_single_page(), which has been used only by the mlx5
driver, holds umem_mutex on success and releases on failure. This
behavior is not convenient for other drivers to use it, so change it to
always retain mutex on return.

Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
---
 drivers/infiniband/core/umem_odp.c | 6 ++----
 drivers/infiniband/hw/mlx5/odp.c   | 4 +++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index c459c4d011cf..92617a021439 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -328,8 +328,8 @@ static int ib_umem_odp_map_dma_single_page(
  *
  * Maps the range passed in the argument to DMA addresses.
  * The DMA addresses of the mapped pages is updated in umem_odp->dma_list.
- * Upon success the ODP MR will be locked to let caller complete its device
- * page table update.
+ * The umem mutex is locked and not released in this function. The caller should
+ * complete its device page table update before releasing the lock.
  *
  * Returns the number of pages mapped in success, negative error code
  * for failure.
@@ -456,8 +456,6 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	/* upon success lock should stay on hold for the callee */
 	if (!ret)
 		ret = dma_index - start_idx;
-	else
-		mutex_unlock(&umem_odp->umem_mutex);
 
 out_put_mm:
 	mmput(owning_mm);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index bc97958818bb..a0de27651586 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -572,8 +572,10 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 		access_mask |= ODP_WRITE_ALLOWED_BIT;
 
 	np = ib_umem_odp_map_dma_and_lock(odp, user_va, bcnt, access_mask, fault);
-	if (np < 0)
+	if (np < 0) {
+		mutex_unlock(&odp->umem_mutex);
 		return np;
+	}
 
 	/*
 	 * No need to check whether the MTTs really belong to this MR, since
-- 
2.31.1

