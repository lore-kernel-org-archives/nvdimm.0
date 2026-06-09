Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EA440BCDA;
	Tue,  9 Jun 2026 12:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006898; cv=pass; b=jcp4oFZnB23Er16ohiRI3gJA/6+yjuuLv1PvvHDxrXUEYFgXWj6ba+qLKHsOfti33ewf8Xjvk+4DiKvU6VB2wKbSsfj+GCKBs+j30lnwF2kUZ7IJZs7JAa/dCgxUQs51oZJIY7B3Hi7+JqAgVoudWyaavzQMXzRp2TDTTJpvOQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006898; c=relaxed/simple;
	bh=GnBkHB2tsKfOTSBG+XpIVJrTWoi3EyC6RCw9K5pXf/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5IZluhRjfYfE3ev4/yGCCu4wkFWgcywT5fQ3QC9IFO5lUe6OC87Z/8AGHRguSSXuHLxtxCKj8UjQZ7+dv8h3lP6htegzcROFBxua48NZvHCeUrqDcWEWYPcax5xUQhw0bKa+UuGM6NJLp+/qyZ5MX+rjc+xYbTh6O5M9nABC7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=gYEx9tWk; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="gYEx9tWk"
ARC-Seal: i=1; a=rsa-sha256; t=1781006880; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=O/qvyAqrW+dQ1Kop74v0Xm88JRX0qF/AuBdG+EHe55MhDKSTI3TgMZ8KTtLGojmZh6MxnS+OXV51W1z17XL6bBtObgPkPutkfBF7CHDuQziq9LZesXqH1ZrjfWGXg803ZFhx2rDx7ec6vUAsrdgH+BlOsXmMOGefEMLgTvPauts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781006880; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=79C1DXTtv5mIJ7drNEJRTgyEFf08rMj3no/LbB3sb3I=; 
	b=hSZQ+mbDJ81XTY5ZQah9jOhHD3M9evvngtn+KZPw9e9xZAoGVVswX3N5s2yEziTKzBIVAfC9GwEaO+vRjlKKPInJvbF8wQnHGgtVOMyR1DRRvjWEiYsf2rnBxPAitm2jAYO6PTOs2XobE3OD/tWv89q7zjDgWy7wZYhJ+ABsHZc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781006880;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=79C1DXTtv5mIJ7drNEJRTgyEFf08rMj3no/LbB3sb3I=;
	b=gYEx9tWk1NNnsoZ0klsu87jLlfYkMPSB74Iacv+RS2zokoQQrcoge6GmDgWe7X+D
	EMIsEieR7GubYhEK+e//Ocn8glbZgZvyxhuyrTpNNdHlWE+RO9pwiObQA1LTLgRr+eH
	SApfma+ac/smT2JksRHOEPjr3Y4x9894WM3AQT8Y=
Received: by mx.zohomail.com with SMTPS id 1781006878827833.794050155962;
	Tue, 9 Jun 2026 05:07:58 -0700 (PDT)
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
Subject: [PATCH v4 3/7] nvdimm: virtio_pmem: always wake -ENOSPC waiters
Date: Tue,  9 Jun 2026 20:07:17 +0800
Message-ID: <20260609120726.1714780-4-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260609120726.1714780-1-me@linux.beauty>
References: <20260609120726.1714780-1-me@linux.beauty>
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

