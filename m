Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E532D4B4B;
	Thu, 25 Dec 2025 04:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766637000; cv=pass; b=HAh0AeF8pZpSlWHBIdMq2R9vyIw087L5npi3Na30xgX8Qpt3JTq8fFnsOkzMUT9qLj9B2KuphaZJAMOwLJU/Pyz7xXNOgdRHxq6q8LVPG7nmpbTT7FNDvEwcLRgx96YXiK/sXhpcKD8foyNyFwIWKqd6NJ6S2jq2MeT3r6CufIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766637000; c=relaxed/simple;
	bh=P7MdJrrOweqn+awN5ug7drafrvynl+/CgZtltePDdFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBJ4C0VCTUc1JDSBfydgfztb4lWxctDQBlgYs7nDbFdJ0iQNRwXd2Tzgg9wtZcF//I3VhqmGpUcJVSjy0XYTIY4hmar675mtNR2jkvvEhKxv9lu+W/z8CEswWer2CXqKEJemzOzb7wU/MNb9nDQidnOgZ1t/9OpQIkyksgI3SBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=QTI+362i; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="QTI+362i"
ARC-Seal: i=1; a=rsa-sha256; t=1766636972; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=J6WJzH9fC/Rhq9iwZqhjkDwou/5eIn62zpYQhWo2EqtZ5Ugct7SkpeUftGaKIkE0Sr9X/dSh8K1HX20AjMnIdQx0Fuz/TJ0anvqfOi925tME9c9rd5AOYTE29zV/SmivIeD23qCCKf8szSxjnJtXam0SuE9zoF+OzosypVL1EBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766636972; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dSJUTum9tVwhRmP/n1Q+8mhg+IIQiW1CAyU6SlA3Qis=; 
	b=YwcIeCi5STz6QmCSHQaKn9MQrQKkVx0mVCY/K1FAC5ieorjhJG2yPsKILUYJSi7giFUK1lUD08Lw9vVBh36MQoEzeSSwmcSDsVecZd97Fd8b+G+HgxUMXq+EfZRbG9KItd7ZCxOu7LmIT9xFO3X+2f7ne/6TpwU4DBldc3WRYjY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766636972;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=dSJUTum9tVwhRmP/n1Q+8mhg+IIQiW1CAyU6SlA3Qis=;
	b=QTI+362iv/AdSJC8G8EsYF1arleNFgZOFT+Yn+HGw8Hmw9EsCfC78x0QitRnc/Dh
	Qb2R0EWJ0CaY1hplJqIn4l93T/Bmnb0kRoH0W+04NWW5e12/32WzVAu3JXbYJNxZ4yN
	7R5pTZqMQPGDt7tCMJ06UNd5O5Tb+wXiL4DeNImE=
Received: by mx.zohomail.com with SMTPS id 1766636969354450.8212224344853;
	Wed, 24 Dec 2025 20:29:29 -0800 (PST)
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
Subject: [PATCH V2 2/5] nvdimm: virtio_pmem: refcount requests for token lifetime
Date: Thu, 25 Dec 2025 12:29:10 +0800
Message-ID: <20251225042915.334117-3-me@linux.beauty>
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

KASAN reports a slab use-after-free from virtio_pmem_host_ack(). It happens
when it wakes a request that has already been freed by the submitter.

This happens when the request token is still reachable via the virtqueue,
but virtio_pmem_flush() returns and frees it.

Fix the token lifetime by refcounting struct virtio_pmem_request.
virtio_pmem_flush() holds a submitter reference, and the virtqueue holds an
extra reference once the request is queued. The completion path drops the
virtqueue reference, and the submitter drops its reference before
returning.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/nvdimm/nd_virtio.c   | 34 +++++++++++++++++++++++++++++-----
 drivers/nvdimm/virtio_pmem.h |  2 ++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 6f9890361d0b..d0385d4646f2 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -9,6 +9,14 @@
 #include "virtio_pmem.h"
 #include "nd.h"
 
+static void virtio_pmem_req_release(struct kref *kref)
+{
+	struct virtio_pmem_request *req;
+
+	req = container_of(kref, struct virtio_pmem_request, kref);
+	kfree(req);
+}
+
 static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 {
 	struct virtio_pmem_request *req_buf;
@@ -36,6 +44,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 		virtio_pmem_wake_one_waiter(vpmem);
 		WRITE_ONCE(req_data->done, true);
 		wake_up(&req_data->host_acked);
+		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 }
@@ -65,6 +74,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	if (!req_data)
 		return -ENOMEM;
 
+	kref_init(&req_data->kref);
 	WRITE_ONCE(req_data->done, false);
 	init_waitqueue_head(&req_data->host_acked);
 	init_waitqueue_head(&req_data->wq_buf);
@@ -82,10 +92,23 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	  * to req_list and wait for host_ack to wake us up when free
 	  * slots are available.
 	  */
-	while ((err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req_data,
-					GFP_ATOMIC)) == -ENOSPC) {
-
-		dev_info(&vdev->dev, "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
+	for (;;) {
+		err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req_data,
+					GFP_ATOMIC);
+		if (!err) {
+			/*
+			 * Take the virtqueue reference while @pmem_lock is
+			 * held so completion cannot run concurrently.
+			 */
+			kref_get(&req_data->kref);
+			break;
+		}
+
+		if (err != -ENOSPC)
+			break;
+
+		dev_info_ratelimited(&vdev->dev,
+				     "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
 		WRITE_ONCE(req_data->wq_buf_avail, false);
 		list_add_tail(&req_data->list, &vpmem->req_list);
 		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -94,6 +117,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
 		spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	}
+
 	err1 = virtqueue_kick(vpmem->req_vq);
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 	/*
@@ -109,7 +133,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-	kfree(req_data);
+	kref_put(&req_data->kref, virtio_pmem_req_release);
 	return err;
 };
 
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 0dddefe594c4..fc8f613f8f28 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -12,10 +12,12 @@
 
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
+#include <linux/kref.h>
 #include <linux/libnvdimm.h>
 #include <linux/spinlock.h>
 
 struct virtio_pmem_request {
+	struct kref kref;
 	struct virtio_pmem_req req;
 	struct virtio_pmem_resp resp;
 
-- 
2.52.0

