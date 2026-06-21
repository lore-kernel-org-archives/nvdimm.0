Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD8C364EB8;
	Sun, 21 Jun 2026 13:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047044; cv=pass; b=EvlIvA5G8UL/QkEXOK5MJt37wnbOZV8oF/xCRl/7R2Zx4HHW+iZphEAun/xWvBuuYygC3tqqxHZUOaR6JaMiwDLhG9WoV/NVIVcLIvs3UtnVeotmdjWP1gux7pBlZQP6sxfTXJeophmAvtabUlNRyqraYj7xryvbkjZhksU7vlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047044; c=relaxed/simple;
	bh=H/nNiBO6U7u4CqbY9F0Hbyz60Ya4J0OQzrwsizH01gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cj5Ul2GSME3lqu+ScLKLjrfbsSr+sdXWDI+3aDkhChJWae/YxDznEN7uR9eyK/anile7O12qFIxYY9pZxcyUcJX+8SC9Z5XPINyRZvBZJ541ecp3egXKprrCW6x6qOGbvPi4I+rTO2yMHA8EN/Mqe5oD1xbL0HGYuzbL8zdiO28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=oIvIg09i; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="oIvIg09i"
ARC-Seal: i=1; a=rsa-sha256; t=1782047022; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iz3Apb/Z2yhuisnKHCdJgZKQqOT0Sn3Fx0CWRdkKHm9n5uhLYERixVNsX+LfoI3ikdEG5uT94XXognSF2/TN9vHsGYVAZMN4U60x8P8HOd000TAQdmU30JQt2xq3sBg6Fj49tlG5secKc5X/m/pNeA5l9O0DiRCKpNft9RRfsdM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047022; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xYqJhk551PY84Z5EkDORmsyNfqwhCUkqdlmRz3F67IQ=; 
	b=IQ86AvVgUKgibRTRpqO+kazfiTIUK0+vdlVGLGrjE180cDsfRSbjk8y4KjmkB1QWqkhBDgt4D6j1Ez9k8G9DnAg1p7rxWMN5NHlo+3xF0j/qNVH6wmrS0cTGAZguNIbNy1v+mHM7RNA1P04j6gLVFGsI5Xo8hvzgigll3wM3nHI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047022;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=xYqJhk551PY84Z5EkDORmsyNfqwhCUkqdlmRz3F67IQ=;
	b=oIvIg09i6WpbQvxfBk4MpZa9xP7xTf9q47eH9FJFS2RmXv/xRVwE+Vzy2egEfJko
	SqxX9cJy36EdpYoYupAivLLPeoVhvx2XiyRH4iAeBMzmGVwAiH+xebgxSR7ZOV08sgL
	ecs+FXMBqW3VrKoTiUtq2AYTQgNDNLbelmTwZCg4=
Received: by mx.zohomail.com with SMTPS id 1782047020733430.6074913642492;
	Sun, 21 Jun 2026 06:03:40 -0700 (PDT)
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
Subject: [PATCH v6 11/12] nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Date: Sun, 21 Jun 2026 21:02:42 +0800
Message-ID: <20260621130246.2973254-12-me@linux.beauty>
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

dmesg reports virtqueue failure and device reset:
virtio_pmem virtio2: failed to send command to
virtio pmem device, no free slots in the virtqueue
virtio_pmem virtio2: virtio pmem device
needs a reset

virtio_pmem_flush() can wait for a free virtqueue descriptor (-ENOSPC).
It can also wait for host completion. If the request virtqueue breaks,
those waiters may never make progress. One example is notify failure from
virtqueue_kick().

Track a device-level broken state and converge the failure to -EIO. New
requests fail fast, -ENOSPC waiters are unlinked and woken, and the
currently submitted request is woken so its host_acked waiter can return
without waiting forever for host completion. Completed requests are forced
to report an error after the queue is marked broken.

Do not detach unused buffers from an active virtqueue. Runtime
broken-queue handling only stops new submissions and wakes local waiters.
Removal resets the device first. It then drains request tokens. After
that, the device no longer owns the buffers when the virtqueue reference
is dropped.

Closes: https://lore.kernel.org/r/202512250116.ewtzlD0g-lkp@intel.com/
Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- Wake the in-flight host-completion waiter when marking the queue broken.
- Track req_inflight and clear it on completion/drain paths.
- Return -EIO if the queue breaks before a host response is observed.
Changes in v5:
- Split broken marking from token draining.
- Do not call virtqueue_detach_unused_buf() on an active queue.
- Reset the device before draining tokens in remove().
- Do not let the host-completion wait return only because the device is
  marked broken.
v2->v3:
- Add raw dmesg excerpt to the patch description.
- Drop timestamps from the embedded dmesg.
- Fold the CONFIG_VIRTIO_PMEM=m export fix into this patch.
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.
- Use kmalloc_obj(*req_data) at the allocation site to match current nvdimm
  code.

 drivers/nvdimm/nd_virtio.c   | 117 +++++++++++++++++++++++++++++++----
 drivers/nvdimm/virtio_pmem.c |  15 ++++-
 drivers/nvdimm/virtio_pmem.h |   8 +++
 3 files changed, 127 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 35d36bd36a526..fb9391ebc46e7 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -30,6 +30,12 @@ static bool virtio_pmem_req_done(struct virtio_pmem_request *req)
 	return smp_load_acquire(&req->done);
 }
 
+static void virtio_pmem_complete_err(struct virtio_pmem_request *req)
+{
+	req->resp.ret = cpu_to_le32(1);
+	virtio_pmem_signal_done(req);
+}
+
 static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 {
 	struct virtio_pmem_request *req_buf;
@@ -44,6 +50,63 @@ static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 	wake_up(&req_buf->wq_buf);
 }
 
+static void virtio_pmem_wake_all_waiters(struct virtio_pmem *vpmem)
+{
+	struct virtio_pmem_request *req, *tmp;
+
+	list_for_each_entry_safe(req, tmp, &vpmem->req_list, list) {
+		list_del_init(&req->list);
+		WRITE_ONCE(req->wq_buf_avail, true);
+		wake_up(&req->wq_buf);
+	}
+}
+
+static void virtio_pmem_clear_inflight(struct virtio_pmem *vpmem,
+				       struct virtio_pmem_request *req)
+{
+	if (vpmem->req_inflight == req)
+		vpmem->req_inflight = NULL;
+}
+
+static void virtio_pmem_wake_inflight(struct virtio_pmem *vpmem)
+{
+	struct virtio_pmem_request *req = vpmem->req_inflight;
+
+	if (req)
+		wake_up(&req->host_acked);
+}
+
+void virtio_pmem_mark_broken(struct virtio_pmem *vpmem)
+{
+	if (!READ_ONCE(vpmem->broken)) {
+		WRITE_ONCE(vpmem->broken, true);
+		dev_err_once(&vpmem->vdev->dev, "virtqueue is broken\n");
+	}
+
+	virtio_pmem_wake_inflight(vpmem);
+	virtio_pmem_wake_all_waiters(vpmem);
+}
+EXPORT_SYMBOL_GPL(virtio_pmem_mark_broken);
+
+void virtio_pmem_drain(struct virtio_pmem *vpmem)
+{
+	struct virtio_pmem_request *req;
+	unsigned int len;
+
+	while ((req = virtqueue_get_buf(vpmem->req_vq, &len)) != NULL) {
+		virtio_pmem_clear_inflight(vpmem, req);
+		virtio_pmem_complete_err(req);
+		kref_put(&req->kref, virtio_pmem_req_release);
+	}
+
+	while ((req = virtqueue_detach_unused_buf(vpmem->req_vq)) != NULL) {
+		virtio_pmem_clear_inflight(vpmem, req);
+		virtio_pmem_complete_err(req);
+		kref_put(&req->kref, virtio_pmem_req_release);
+	}
+}
+EXPORT_SYMBOL_GPL(virtio_pmem_drain);
+
  /* The interrupt handler */
 void virtio_pmem_host_ack(struct virtqueue *vq)
 {
@@ -54,8 +117,12 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
+		virtio_pmem_clear_inflight(vpmem, req_data);
 		virtio_pmem_wake_one_waiter(vpmem);
-		virtio_pmem_signal_done(req_data);
+		if (READ_ONCE(vpmem->broken))
+			virtio_pmem_complete_err(req_data);
+		else
+			virtio_pmem_signal_done(req_data);
 		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -83,6 +150,9 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
+	if (READ_ONCE(vpmem->broken))
+		return -EIO;
+
 	req_data = kmalloc_obj(*req_data, GFP_NOIO);
 	if (!req_data)
 		return -ENOMEM;
@@ -99,13 +169,18 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	sgs[1] = &ret;
 
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
-	 /*
-	  * If virtqueue_add_sgs returns -ENOSPC then req_vq virtual
-	  * queue does not have free descriptor. We add the request
-	  * to req_list and wait for host_ack to wake us up when free
-	  * slots are available.
-	  */
+	/*
+	 * If virtqueue_add_sgs returns -ENOSPC then req_vq virtual
+	 * queue does not have free descriptor. We add the request
+	 * to req_list and wait for host_ack to wake us up when free
+	 * slots are available.
+	 */
 	for (;;) {
+		if (READ_ONCE(vpmem->broken)) {
+			err = -EIO;
+			break;
+		}
+
 		err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req_data,
 					GFP_ATOMIC);
 		if (!err) {
@@ -114,6 +189,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 			 * held so completion cannot run concurrently.
 			 */
 			kref_get(&req_data->kref);
+			vpmem->req_inflight = req_data;
 			break;
 		}
 
@@ -127,24 +203,41 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
+		wait_event(req_data->wq_buf,
+			   READ_ONCE(req_data->wq_buf_avail) ||
+			   READ_ONCE(vpmem->broken));
 		spin_lock_irqsave(&vpmem->pmem_lock, flags);
+
+		if (READ_ONCE(vpmem->broken))
+			break;
 	}
 
-	err1 = virtqueue_kick(vpmem->req_vq);
+	if (err == -EIO || virtqueue_is_broken(vpmem->req_vq))
+		virtio_pmem_mark_broken(vpmem);
+
+	err1 = true;
+	if (!err && !READ_ONCE(vpmem->broken)) {
+		err1 = virtqueue_kick(vpmem->req_vq);
+		if (!err1)
+			virtio_pmem_mark_broken(vpmem);
+	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 	/*
 	 * virtqueue_add_sgs failed with error different than -ENOSPC, we can't
 	 * do anything about that.
 	 */
-	if (err || !err1) {
+	if (READ_ONCE(vpmem->broken) || err || !err1) {
 		dev_info(&vdev->dev, "failed to send command to virtio pmem device\n");
 		err = -EIO;
 	} else {
 		/* A host response results in "host_ack" getting called */
 		wait_event(req_data->host_acked,
-			   virtio_pmem_req_done(req_data));
-		err = le32_to_cpu(req_data->resp.ret);
+			   virtio_pmem_req_done(req_data) ||
+			   READ_ONCE(vpmem->broken));
+		if (virtio_pmem_req_done(req_data))
+			err = le32_to_cpu(req_data->resp.ret);
+		else
+			err = -EIO;
 	}
 
 	kref_put(&req_data->kref, virtio_pmem_req_release);
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 77b1966619059..b272e9279ef23 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -25,6 +25,8 @@ static int init_vq(struct virtio_pmem *vpmem)
 
 	spin_lock_init(&vpmem->pmem_lock);
 	INIT_LIST_HEAD(&vpmem->req_list);
+	vpmem->req_inflight = NULL;
+	WRITE_ONCE(vpmem->broken, false);
 
 	return 0;
 };
@@ -138,10 +140,21 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 static void virtio_pmem_remove(struct virtio_device *vdev)
 {
 	struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
+	struct virtio_pmem *vpmem = vdev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_mark_broken(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
+	virtio_reset_device(vdev);
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_drain(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 	nvdimm_bus_unregister(nvdimm_bus);
 	vdev->config->del_vqs(vdev);
-	virtio_reset_device(vdev);
 }
 
 static int virtio_pmem_freeze(struct virtio_device *vdev)
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 23bff40249c1b..bc7de2b328985 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -52,6 +52,12 @@ struct virtio_pmem {
 	/* List to store deferred work if virtqueue is full */
 	struct list_head req_list;
 
+	/* Request currently owned by the virtqueue. */
+	struct virtio_pmem_request *req_inflight;
+
+	/* Fail fast and wake waiters if the request virtqueue is broken. */
+	bool broken;
+
 	/* Synchronize virtqueue data */
 	spinlock_t pmem_lock;
 
@@ -61,5 +67,7 @@ struct virtio_pmem {
 };
 
 void virtio_pmem_host_ack(struct virtqueue *vq);
+void virtio_pmem_mark_broken(struct virtio_pmem *vpmem);
+void virtio_pmem_drain(struct virtio_pmem *vpmem);
 int async_pmem_flush(struct nd_region *nd_region, struct bio *bio);
 #endif
-- 
2.52.0
