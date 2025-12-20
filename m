Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754342F549D;
	Sat, 20 Dec 2025 08:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766219701; cv=pass; b=U3poA1vLf3NWss6UaKGSQFWCUYT+HLxvcj8F9q5zqa9TKKzHnMbMSlt6Uns93eCDfE44wWA7YhJyyhbLwmnghjYvUMqj0KPwd3OwWIcuL80Mvb3QO3prhP4Ju6YilpuwWTuXrmkneI5cq0lHbTeBmINNxZw9LXlneB+dMT8OfeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766219701; c=relaxed/simple;
	bh=UpBQjzOv2zWJm0MiE40rFexes1ffQA8ZykCSkFpddhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHQAj4ajn0wuMpMJjQz7s46LeuU8LzpPhLn2+7e6zGGCvOsTjs5jDvQpKglCcADybk3v5s1na/3r422uiyKHlwRa3vrqYXY7X2z1am2qn0isAuDPeLxBnNv0jqy5YvM474QqgPVXBbgSoWJlycr6d0K21uAua+ZyxRg/gQoMWvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=sgu8AE7P; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="sgu8AE7P"
ARC-Seal: i=1; a=rsa-sha256; t=1766219694; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=F6xkMlVw2L1Bipdj2Ma32EA2LTgqTXvZ9e4y8LkQnmUQzoRpP9XeaOniTte9zppx2b1SXQmsvag0iZtNVHlw5zwxAIuonCIVpwJbYCTUKjPgQEae0tjBpO0CudhMSXBGLU4RbX567L9G3sHVT18Vcj/UqadXHEB5IKDQPCD8K1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766219694; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=5InwQq38W8dhaMny4s4eL6hBKvOJdW7iE44wBOaPYsE=; 
	b=PRVrZb0ZhZh11g9TpfV147HpUCr0r8iCh4OTOiJaolNvv/ezoPmOanHsYBXBpzxr95aBGOeVYeVRcRDwxyHPBKfLtaF6RvLWUwrxiJYuiyPCFBSW5FBgC3GPsTpHW0jIFeGD/Tkg7VvkPeLF/+PEOvrgUs70fWKAma30ywTIkCg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766219694;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=5InwQq38W8dhaMny4s4eL6hBKvOJdW7iE44wBOaPYsE=;
	b=sgu8AE7PCzvD6PyY8+lKT2wTsvgH8kM5EHNDkkmDpypDyXArHO0sWLnBdQ5UWJ7d
	tPa8nw5vNv+lykg23+U8Focltd2xfdj+1h5Qg4yBcS1Xkw3Yq/LEY9kFZ15/SzFb87Q
	QgapBF8KNi864CVJCKxwmBFLzOmaUi9e1u4ZV9cM=
Received: by mx.zohomail.com with SMTPS id 1766219692437326.47273936198314;
	Sat, 20 Dec 2025 00:34:52 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH 1/4] nvdimm: virtio_pmem: always wake -ENOSPC waiters
Date: Sat, 20 Dec 2025 16:34:37 +0800
Message-ID: <20251220083441.313737-2-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251220083441.313737-1-me@linux.beauty>
References: <20251220083441.313737-1-me@linux.beauty>
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
2.51.0

