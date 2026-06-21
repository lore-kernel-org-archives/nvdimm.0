Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195BB3403F1;
	Sun, 21 Jun 2026 13:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047020; cv=pass; b=s1wRNjP7UOHZznPBxl2nlkp64BtJFZBLXwj4VDoEcZPTRH1733ruYIeyNInE9cLt43MuwYEeQHeDOpG3Ka/61Ri45Dtwp5wLk4q1yj88x1iX5JbXhn7uPWYYV7fwqUBlFLPCKfOLVxND3YoA1y7am435YpqXIynr8zCd/NaJrTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047020; c=relaxed/simple;
	bh=q/GRfoSlw5dIy2Aus/xfpx0LMjWlGNXaHPaEwSblvUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3iAl3wjEImpxCqs9q/sulO8okRBzRSBrCCojXjG5JLoURmNkON4eizrGwSNyy+KDhgSQWzCoaonNfPQZy8WAtkyCgZojgYGcGy3OIQImnpgXuFQAH/lMVDATeCahjcSBIpqRR6Zy56AU9zd59dTreEyNKbA5wkVu5uZPH3wp00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=BnBZErVk; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="BnBZErVk"
ARC-Seal: i=1; a=rsa-sha256; t=1782047006; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fAVjLuq8Ruy8DtKDTxh4TXjOIz82y/rghiiiIWpKYkhO2YbYonBasBVliq9TuoE9mmSekw/lHyYJbJUKCioU1xJlhNO8U58dwNbJbNJvtWcIC+3O8GZL/HiTrd7cgxRcceilpz0GPbxbzKtni8J6YujjCppxAKd99sd+0ydTuug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047006; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7/P+RfQlAxUphbROAQccTU2vS2PxCRT9XWwAjXeYZMY=; 
	b=FIFNfm9jjnBHkYV4gVC0kELekgCxD7knT7v6fsiiLuYxGlGr/XsMcnYGmMm7f+Rp1Wu676mZHxdnC9lAPK5Ri8Aa6BtV0eBpm+L8cvDfH9CSrv5x9M0HNldyc1W9BQOK0epmO8DUI/L/jqDyD0Yso87xuWSg3wc9TD6xQZpQT/Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047006;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7/P+RfQlAxUphbROAQccTU2vS2PxCRT9XWwAjXeYZMY=;
	b=BnBZErVkfu4TSWy/xSByAym1XakIduIdJA5WYb0IjWYZKrHfreimaZIJnDSjI5uw
	80t4iggeoetaAHiisLfbFJpfam3MtNGmYpCXDTjwCg800uae8JDNwOSFpgdig2lfzXd
	msMv7mpJJHzebAsUrzNrQXPMzmdPW1ol+HfET3N8=
Received: by mx.zohomail.com with SMTPS id 1782047002784416.09041512376143;
	Sun, 21 Jun 2026 06:03:22 -0700 (PDT)
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
Subject: [PATCH v6 06/12] nvdimm: virtio_pmem: always wake -ENOSPC waiters
Date: Sun, 21 Jun 2026 21:02:37 +0800
Message-ID: <20260621130246.2973254-7-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260621130246.2973254-1-me@linux.beauty>
References: <20260621130246.2973254-1-me@linux.beauty>
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
index 91ca144607531..8ed4d6b3a9284 100644
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
