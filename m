Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7103815D1;
	Thu, 26 Feb 2026 02:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074680; cv=pass; b=p9bXUb9vHzN+V+CNkEicaQ24H29rEmM+iUg9I36zb+jZ0y5XqrspB2Wz3RvF5MMHee6BUlg8XXH2DMwMmhjh21mWg3/iFc7LdiUyIb13K/jF/wAV51z8Xqhjv5jm1zSnmY5Pad1A5wmeMbrMGvRBXQ8LrbKDnAKEyeE1zVYpFR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074680; c=relaxed/simple;
	bh=elU91PbJP9nNAoNweoVHyYXsTEP00Q5mA9Ti6lDe5vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw7TimfKFsD7W05/KWXoAgXWlCs8zUWfP8Jsp2bOfN4aDxSQB8/kkBkZFqJn1EdFLXFwYDKj8QD3i/mEh2KWeMz8o56eO43fQKDajGAuIKdGhQ/hYqwykcrDSBdc5Dz6DDNhjXiBC6Fd5D3m911umtkEBaJ4EmFslvmPdjmF1dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=QQ9s+NWz; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="QQ9s+NWz"
ARC-Seal: i=1; a=rsa-sha256; t=1772074663; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=md8Qb9eIwjwS1FMGUHCYEfYYOdDnMSnX+pttptP8BO+qk0SBr/QcBb7njY//oW5cr5aVV+01vpJlrNIVpbeuB6YBasuMk+Gyg5vR250SKsbBaokuT6j62v84Wlw/EmJSfzg9p4Z5IrpFLFdz6DiHJ7obRNB4jp7b9oIXZeXjLMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772074663; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dmfPIu9iVjuDRJWpKWNNYGGhOCMNg5d6TcsUNer2OC0=; 
	b=f6Ob0hdQCMZSje+hBI/iDQ1iF+jWbYQGJOzX8yUdAN7Te6yKvC4PMd+22ELlNLIisDjiV74XDqs9yllCB/uMI0q2+ImqyeonfvuEkQi1ROWM/We34kwUIUuFEJrIRWS0CWx++r0aHEf30xjibEPKiIY5dtSBmcUI4PQ4k3nhB4o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772074663;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=dmfPIu9iVjuDRJWpKWNNYGGhOCMNg5d6TcsUNer2OC0=;
	b=QQ9s+NWzOGOl/nPI47adj2IultgtVL/ewwmVxqKWMzXh5ixD2Vb+6eV1rtJhXGkh
	AY36U7nAw1i4rNWhDPv73l95FdGBEK1PvyGIw4/iKDUeOCxmyDvg90W6j2lUG7JuS55
	zfkzZAKZxKhUkr/IOr3nO2M0wHa96AlRABbQNYtM=
Received: by mx.zohomail.com with SMTPS id 1772074662694965.4303695951443;
	Wed, 25 Feb 2026 18:57:42 -0800 (PST)
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
Subject: [PATCH v3 4/5] nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Date: Thu, 26 Feb 2026 10:57:09 +0800
Message-ID: <20260226025712.2236279-5-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260226025712.2236279-1-me@linux.beauty>
References: <20260226025712.2236279-1-me@linux.beauty>
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

virtio_pmem_flush() waits for either a free virtqueue descriptor (-ENOSPC)
or a host completion. If the request virtqueue becomes broken (e.g.
virtqueue_kick() notify failure), those waiters may never make progress.

Track a device-level broken state and converge all error paths to -EIO.
Fail fast for new requests, wake all -ENOSPC waiters, and drain/detach
outstanding request tokens to complete them with an error.

Closes: https://lore.kernel.org/oe-kbuild-all/202512250116.ewtzlD0g-lkp@intel.com/
Signed-off-by: Li Chen <me@linux.beauty>
---
v2->v3:
- Add raw dmesg excerpt to the patch description.
- Fold the CONFIG_VIRTIO_PMEM=m export fix into this patch.

 drivers/nvdimm/nd_virtio.c   | 76 +++++++++++++++++++++++++++++++++---
 drivers/nvdimm/virtio_pmem.c |  7 ++++
 drivers/nvdimm/virtio_pmem.h |  4 ++
 3 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index d0bf213d8caf..7a62aa7ce254 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -17,6 +17,18 @@ static void virtio_pmem_req_release(struct kref *kref)
 	kfree(req);
 }
 
+static void virtio_pmem_signal_done(struct virtio_pmem_request *req)
+{
+	WRITE_ONCE(req->done, true);
+	wake_up(&req->host_acked);
+}
+
+static void virtio_pmem_complete_err(struct virtio_pmem_request *req)
+{
+	req->resp.ret = cpu_to_le32(1);
+	virtio_pmem_signal_done(req);
+}
+
 static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 {
 	struct virtio_pmem_request *req_buf;
@@ -31,6 +43,41 @@ static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 	wake_up(&req_buf->wq_buf);
 }
 
+static void virtio_pmem_wake_all_waiters(struct virtio_pmem *vpmem)
+{
+	struct virtio_pmem_request *req, *tmp;
+
+	list_for_each_entry_safe(req, tmp, &vpmem->req_list, list) {
+		WRITE_ONCE(req->wq_buf_avail, true);
+		wake_up(&req->wq_buf);
+		list_del_init(&req->list);
+	}
+}
+
+void virtio_pmem_mark_broken_and_drain(struct virtio_pmem *vpmem)
+{
+	struct virtio_pmem_request *req;
+	unsigned int len;
+
+	if (READ_ONCE(vpmem->broken))
+		return;
+
+	WRITE_ONCE(vpmem->broken, true);
+	dev_err_once(&vpmem->vdev->dev, "virtqueue is broken\n");
+	virtio_pmem_wake_all_waiters(vpmem);
+
+	while ((req = virtqueue_get_buf(vpmem->req_vq, &len)) != NULL) {
+		virtio_pmem_complete_err(req);
+		kref_put(&req->kref, virtio_pmem_req_release);
+	}
+
+	while ((req = virtqueue_detach_unused_buf(vpmem->req_vq)) != NULL) {
+		virtio_pmem_complete_err(req);
+		kref_put(&req->kref, virtio_pmem_req_release);
+	}
+}
+EXPORT_SYMBOL_GPL(virtio_pmem_mark_broken_and_drain);
+
  /* The interrupt handler */
 void virtio_pmem_host_ack(struct virtqueue *vq)
 {
@@ -42,8 +89,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
 		virtio_pmem_wake_one_waiter(vpmem);
-		WRITE_ONCE(req_data->done, true);
-		wake_up(&req_data->host_acked);
+		virtio_pmem_signal_done(req_data);
 		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -71,6 +117,9 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
+	if (READ_ONCE(vpmem->broken))
+		return -EIO;
+
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
 		return -ENOMEM;
@@ -115,22 +164,37 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
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
+		virtio_pmem_mark_broken_and_drain(vpmem);
+
+	err1 = true;
+	if (!err && !READ_ONCE(vpmem->broken)) {
+		err1 = virtqueue_kick(vpmem->req_vq);
+		if (!err1)
+			virtio_pmem_mark_broken_and_drain(vpmem);
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
-		wait_event(req_data->host_acked, READ_ONCE(req_data->done));
+		wait_event(req_data->host_acked,
+			   READ_ONCE(req_data->done) ||
+			   READ_ONCE(vpmem->broken));
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 77b196661905..c5caf11a479a 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -25,6 +25,7 @@ static int init_vq(struct virtio_pmem *vpmem)
 
 	spin_lock_init(&vpmem->pmem_lock);
 	INIT_LIST_HEAD(&vpmem->req_list);
+	WRITE_ONCE(vpmem->broken, false);
 
 	return 0;
 };
@@ -138,6 +139,12 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 static void virtio_pmem_remove(struct virtio_device *vdev)
 {
 	struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
+	struct virtio_pmem *vpmem = vdev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_mark_broken_and_drain(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 	nvdimm_bus_unregister(nvdimm_bus);
 	vdev->config->del_vqs(vdev);
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 1017e498c9b4..e1a46abb9483 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -48,6 +48,9 @@ struct virtio_pmem {
 	/* List to store deferred work if virtqueue is full */
 	struct list_head req_list;
 
+	/* Fail fast and wake waiters if the request virtqueue is broken. */
+	bool broken;
+
 	/* Synchronize virtqueue data */
 	spinlock_t pmem_lock;
 
@@ -57,5 +60,6 @@ struct virtio_pmem {
 };
 
 void virtio_pmem_host_ack(struct virtqueue *vq);
+void virtio_pmem_mark_broken_and_drain(struct virtio_pmem *vpmem);
 int async_pmem_flush(struct nd_region *nd_region, struct bio *bio);
 #endif
-- 
2.52.0
