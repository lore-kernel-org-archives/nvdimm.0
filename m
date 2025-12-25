Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BA32D3A86;
	Thu, 25 Dec 2025 04:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766636989; cv=pass; b=U/AkBDxAGSwq+a8WXwdQEUS5g1GhefhyHWBi1AgFfxzqEMW6D2uSkTbrfUeuQiF5WacKvoApAvLr9GyJV+w6BPUmpfPuPGOxm5fyvTKunLEMqGntemtj9OlMjlpEpFUgZql49p1yziqUN7korujM8K1QEe1hkJJkoED1dIrse/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766636989; c=relaxed/simple;
	bh=5DNOxpsAuuOrylW+rjO2emqxL1JAJ5YvHZehrTPmfWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4k90Ht9KefgpKiX5KQOyshINSUrqLm+w7Z9w6QlH365r3xfQjNGW4/xUlRgRTX2mnKgjnlvEbwZ+DX/T8rwNst1vj6BnXjGBf7g5r46jR90q2AJobEjXZavoUVyk0fanBLug7Qhl5bjeQwt0VB4hUcao3eBjhd5/DsUrCITnmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=eT48T/IP; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="eT48T/IP"
ARC-Seal: i=1; a=rsa-sha256; t=1766636968; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QGzK6rTVlGVBmAL1xIYXVhwM8bp63qVb2yBCtek7+5TLV1eROE4G8+CpXyO1ndurKY5tHFpHV4a0uOT7EbCtzOEpUQ9cAwyWDjCa1P85Tj8J/ejpchh9F/JOUi88hGkeprc29d+y0k/MglujGULxL3yk3l5gsco6kWq5dtuDCLU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766636968; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=mfOi8qOrh2g3wFJTwUHxWZlTMKGv7eV+gj42v7SqpqM=; 
	b=f6Tsr/oEw0hwimwfx9j5ZtKkIO8frhtVGCJ1O7lmjvlcu4uD3XzeMKW70mCYHkuPA1CjYS2pvXkm3iiK44K8bbv0VXanY42FlMkjX5iJKAVGbxhJ75UeBjGsvU8Q/CUdBZElNdXN288Ejwtq8wuNUTq0huxu/viA0QGnGc7iRAM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766636968;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=mfOi8qOrh2g3wFJTwUHxWZlTMKGv7eV+gj42v7SqpqM=;
	b=eT48T/IPHV1Ft10ujX9/GKyMxZl1CB7wtnN9zmAdEDDfD8z/sTGbpOC8ZpQOjeSh
	mfur08LNmEf2P+jfl/A3226gjGHGeR3BK80OJEiEm9VaNdPJU41GML7EfopRrKwX9a6
	hGuXi9yxlLOmdWP0IQxJbeQfP0VulUd/qygPvcgc=
Received: by mx.zohomail.com with SMTPS id 1766636965454524.6090032100158;
	Wed, 24 Dec 2025 20:29:25 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH V2 1/5] nvdimm: virtio_pmem: always wake -ENOSPC waiters
Date: Thu, 25 Dec 2025 12:29:09 +0800
Message-ID: <20251225042915.334117-2-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251225042915.334117-1-me@linux.beauty>
References: <20251225042915.334117-1-me@linux.beauty>
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
returned token.

If token completion is skipped for any reason, reclaimed descriptors may
not wake a waiter and the submitter may sleep forever waiting for a free
slot.

Always wake one -ENOSPC waiter for each virtqueue completion before
touching the returned token.

Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
wq_buf_avail). They are observed by waiters without pmem_lock, so make
the accesses explicit single loads/stores and avoid compiler
reordering/caching across the wait/wake paths.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/nvdimm/nd_virtio.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa22..6f9890361d0b 100644
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
+				  struct virtio_pmem_request, list);
+	list_del_init(&req_buf->list);
+	WRITE_ONCE(req_buf->wq_buf_avail, true);
+	wake_up(&req_buf->wq_buf);
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
-		req_data->done = true;
+		virtio_pmem_wake_one_waiter(vpmem);
+		WRITE_ONCE(req_data->done, true);
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
@@ -58,7 +65,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	if (!req_data)
 		return -ENOMEM;
 
-	req_data->done = false;
+	WRITE_ONCE(req_data->done, false);
 	init_waitqueue_head(&req_data->host_acked);
 	init_waitqueue_head(&req_data->wq_buf);
 	INIT_LIST_HEAD(&req_data->list);
@@ -79,12 +86,12 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 					GFP_ATOMIC)) == -ENOSPC) {
 
 		dev_info(&vdev->dev, "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
-		req_data->wq_buf_avail = false;
+		WRITE_ONCE(req_data->wq_buf_avail, false);
 		list_add_tail(&req_data->list, &vpmem->req_list);
 		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->wq_buf, req_data->wq_buf_avail);
+		wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
 		spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	}
 	err1 = virtqueue_kick(vpmem->req_vq);
@@ -98,7 +105,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		err = -EIO;
 	} else {
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->host_acked, req_data->done);
+		wait_event(req_data->host_acked, READ_ONCE(req_data->done));
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-- 
2.52.0

