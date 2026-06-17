Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB2F3B4EBC;
	Wed, 17 Jun 2026 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699147; cv=pass; b=pc4FYl5JWkcsj9gLG9CgSBK4qX5UTa1coB+2obwjsfA4d+rkC3UISst+Jxah8R7bLu1z0lJu5cLFvFJqYeBBo8pGKuwsbmGaF+XybS3IPbmFngklBlSNaAWBrK/4oIwyeee0utmE0TjZKePyfIp+WWbXSk/RvldTQAy0vEbCNK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699147; c=relaxed/simple;
	bh=GnBkHB2tsKfOTSBG+XpIVJrTWoi3EyC6RCw9K5pXf/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nvk0bV6fPvN+MWyJJWXYn0ynQXyS8ZRgjk1jt7nrF6LktkDTKb/ReJPnOBWU83R3s2BJgRSpHr31X9OD4vUVMeef0QZkg9g/oCvMYhPrNtMLvYS+cK4OV4cYFfuf9K2b/nZCPv9Am7WnNbNd5LmB50f7UhYBJkVduw9yG0rj80Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=gYqJuCH4; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="gYqJuCH4"
ARC-Seal: i=1; a=rsa-sha256; t=1781699118; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ispkE79M77tq0kS+OrOhhv2ZaL+6dy4oumPqOvTc0x4FjHF2aAkLOolB//8dOQrVLYsUAzW7f0F3QX8OJtKuQhuYdM1maRe4bVY3gzwQ4bXu3Yt1u9kaGjaIMPjHRpZRKAvQ5talJ/s/Xxk9k6b78LautrJajZg2LgAHFL0Fdcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781699118; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=79C1DXTtv5mIJ7drNEJRTgyEFf08rMj3no/LbB3sb3I=; 
	b=Dc+naFy0bsonvBsJn4qN18tx+ZsCovwRzyu1yOoJdtPv+S2np30QKeU82zJLU+s75yfoihbfFpnqyv98iyJwtHIn5FJSMBzHvqbURTInDNdKv13JJMzZa+KRPHExYc2UhPiyJ5XYSanGBIwDZ3oJPepNJ0jT58Moyt0AjhboXKY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781699118;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=79C1DXTtv5mIJ7drNEJRTgyEFf08rMj3no/LbB3sb3I=;
	b=gYqJuCH4GYX3YQ6RMsUii/yeBimQJcEEqjBWwHmsRzZwhLSgHuA+bSSb1AAot89q
	syayYEAlO1JZdfE3VA2Yut77tY7NrqGJRlh0lz/lFGSqxKEAY2Yp49KhdAygwFktNvK
	R5cCtxW1YcMcmCVUvCmsu9Dnsu6TUA3FymPcE0ws=
Received: by mx.zohomail.com with SMTPS id 17816991162441001.8892699418471;
	Wed, 17 Jun 2026 05:25:16 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v5 4/8] nvdimm: virtio_pmem: always wake -ENOSPC waiters
Date: Wed, 17 Jun 2026 20:24:36 +0800
Message-ID: <20260617122442.2118957-5-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260617122442.2118957-1-me@linux.beauty>
References: <20260617122442.2118957-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

virtio_pmem_host_ack() reclaims virtqueue descriptors with
virtqueue_get_buf(). The -ENOSPC waiter wakeup is tied to completing the
returned token. If token completion is skipped for any reason, reclaimed
descriptors may not wake a waiter and the submitter may sleep forever
waiting for a free slot. Always wake one -ENOSPC waiter for each virtqueue
completion before touching the returned token.

Signed-off-by: Li Chen <me@linux.beauty>
---
v2->v3:
- Split out the waiter wakeup ordering change from READ_ONCE()/WRITE_ONCE()
  updates (now patch 4/7), per Pankaj's suggestion.
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.

 drivers/nvdimm/nd_virtio.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 081370aac6317..16ee5a47b9938 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -9,26 +9,33 @@
 #include "virtio_pmem.h"
 #include "nd.h"
 
+static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
+{
+	struct virtio_pmem_request *req_buf;
+
+	if (list_empty(&vpmem->req_list))
+		return;
+
+	req_buf = list_first_entry(&vpmem->req_list,
+				   struct virtio_pmem_request, list);
+	req_buf->wq_buf_avail = true;
+	wake_up(&req_buf->wq_buf);
+	list_del(&req_buf->list);
+}
+
  /* The interrupt handler */
 void virtio_pmem_host_ack(struct virtqueue *vq)
 {
 	struct virtio_pmem *vpmem = vq->vdev->priv;
-	struct virtio_pmem_request *req_data, *req_buf;
+	struct virtio_pmem_request *req_data;
 	unsigned long flags;
 	unsigned int len;
 
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
+		virtio_pmem_wake_one_waiter(vpmem);
 		req_data->done = true;
 		wake_up(&req_data->host_acked);
-
-		if (!list_empty(&vpmem->req_list)) {
-			req_buf = list_first_entry(&vpmem->req_list,
-					struct virtio_pmem_request, list);
-			req_buf->wq_buf_avail = true;
-			wake_up(&req_buf->wq_buf);
-			list_del(&req_buf->list);
-		}
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 }
-- 
2.52.0
