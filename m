Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F8781A
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 09:25:02 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="75166303"
X-IronPort-AV: E=Sophos;i="5.96,156,1665414000"; 
   d="scan'208";a="75166303"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP; 11 Nov 2022 18:23:52 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 74752D3EA3
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 18:23:52 +0900 (JST)
Received: from m3004.s.css.fujitsu.com (m3004.s.css.fujitsu.com [10.128.233.124])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id C684FF0FD1
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 18:23:51 +0900 (JST)
Received: from localhost.localdomain (unknown [10.19.3.107])
	by m3004.s.css.fujitsu.com (Postfix) with ESMTP id 9083620607A2;
	Fri, 11 Nov 2022 18:23:51 +0900 (JST)
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
Subject: [RFC PATCH v2 1/7] IB/mlx5: Change ib_umem_odp_map_dma_single_page() to retain umem_mutex
Date: Fri, 11 Nov 2022 18:22:22 +0900
Message-Id: <b9974985069900c80b8ff9e6b0b0b346c1592910.1668157436.git.matsuda-daisuke@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668157436.git.matsuda-daisuke@fujitsu.com>
References: <cover.1668157436.git.matsuda-daisuke@fujitsu.com>
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
 drivers/infiniband/core/umem_odp.c | 8 +++-----
 drivers/infiniband/hw/mlx5/odp.c   | 4 +++-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index e9fa22d31c23..49da6735f7c8 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -328,8 +328,8 @@ static int ib_umem_odp_map_dma_single_page(
  *
  * Maps the range passed in the argument to DMA addresses.
  * The DMA addresses of the mapped pages is updated in umem_odp->dma_list.
- * Upon success the ODP MR will be locked to let caller complete its device
- * page table update.
+ * The umem mutex is locked in this function. Callers are responsible for
+ * releasing the lock.
  *
  * Returns the number of pages mapped in success, negative error code
  * for failure.
@@ -453,11 +453,9 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 			break;
 		}
 	}
-	/* upon success lock should stay on hold for the callee */
+
 	if (!ret)
 		ret = dma_index - start_idx;
-	else
-		mutex_unlock(&umem_odp->umem_mutex);
 
 out_put_mm:
 	mmput_async(owning_mm);
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

