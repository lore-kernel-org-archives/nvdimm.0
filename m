Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170AC2D73A1;
	Thu, 25 Dec 2025 04:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766637008; cv=pass; b=tXVUf/SsWWJeCK0P3cIZ7LPgP5f+uJFhBmqahGeeqa+MVYIjlhM1TiSSzC45oXyR78k13izE3gVJfw6uazL+pa1wzuhZ0Ip9tERwOq5Xp3wiZNzOqZGXjaKdGrvSky/jiZke/rtAlPrmd0pyXlSurKkK/DUuHX9SvNHUstX9W9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766637008; c=relaxed/simple;
	bh=NKvd/+tYecCEMrXxwsKIas9vAt6h21VhWvobet9on7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYo0Vm3DMgrDnHpN/seeWTkpfcnmBe/MffKmhrAZHGpM6taUcdzFkPX3k44++EoNnEy08CQL+Gj84sT+3p1d0WNe3RZwus/wDTyf1Z0ZXkCj5k4mAMN8c6vhy54XAxJPOumI5bpzh6llcx03Ta6cMZM9KCNaeR2ulgkFDGixtbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=tI4f+PHX; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="tI4f+PHX"
ARC-Seal: i=1; a=rsa-sha256; t=1766636978; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mj/658IHAciprjVc8eFLBFi/mWEl/Ax6XC0jLmgGtazLG5NbbVJI5YVKtPlVcbTHH58sv16sDJzYS08xC8s7NZwpY/oij0RQC6QUPrUQXPmMsamW0od36fmj/46AviInCSzr6IH4FuilTvt4r/QiW3dDuWcSoRKhoE2Ay8assIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766636978; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=kJF4gdUrN1RWIspzsiP0AMfYxj80Tonv1/R4T+fQ7FQ=; 
	b=RZZlCOaCo3d31wFP+8nhe3UeX9qVBe67nUb1mz8U/3DbSCuHuTs+UlHGBX8WrsiTL47vd/qo2HuStuNz2u71c7/mfa7fWAg0tOK/zPXZd98hIQIJ0epap3GExp2MLkQ5ghNavQVmE7rFuzjnb70Z/xeRlKY9ud1FJZi2U9p55N0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766636978;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=kJF4gdUrN1RWIspzsiP0AMfYxj80Tonv1/R4T+fQ7FQ=;
	b=tI4f+PHXbw4EXh1juDoLwlv/oQZiDFrKQJuP69hPcJunYDXWfqfWTNAKaHhLflZ5
	B7/KQJRs1nWjYfF3ZCMEHTlzK7/cwvHa+wEGTksfvimLUITcUVUi8/feU7OVhTwDkqZ
	DbbPezdkKEYj1oUnT8mykXL4Z/WimzDu7KwCghDk=
Received: by mx.zohomail.com with SMTPS id 1766636977078588.3208836388319;
	Wed, 24 Dec 2025 20:29:37 -0800 (PST)
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
Subject: [PATCH V2 3/5] nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Date: Thu, 25 Dec 2025 12:29:11 +0800
Message-ID: <20251225042915.334117-4-me@linux.beauty>
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

virtio_pmem_flush() waits for either a free virtqueue descriptor (-ENOSPC)
or a host completion. If the request virtqueue becomes broken (e.g.
virtqueue_kick() notify failure), those waiters may never make progress.

Track a device-level broken state and converge all error paths to -EIO.
Fail fast for new requests, wake all -ENOSPC waiters, and drain/detach
outstanding request tokens to complete them with an error.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/nvdimm/nd_virtio.c   | 73 +++++++++++++++++++++++++++++++++---
 drivers/nvdimm/virtio_pmem.c |  7 ++++
 drivers/nvdimm/virtio_pmem.h |  4 ++
 3 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index d0385d4646f2..de1e3dde85eb 100644
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
@@ -31,6 +43,40 @@ static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
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
+
  /* The interrupt handler */
 void virtio_pmem_host_ack(struct virtqueue *vq)
 {
@@ -42,8 +88,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
 		virtio_pmem_wake_one_waiter(vpmem);
-		WRITE_ONCE(req_data->done, true);
-		wake_up(&req_data->host_acked);
+		virtio_pmem_signal_done(req_data);
 		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -69,6 +114,9 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
+	if (READ_ONCE(vpmem->broken))
+		return -EIO;
+
 	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
@@ -114,22 +162,35 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
+		wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail) ||
+					    READ_ONCE(vpmem->broken));
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
+		wait_event(req_data->host_acked, READ_ONCE(req_data->done) ||
+					    READ_ONCE(vpmem->broken));
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 2396d19ce549..aa07328e3ff9 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -25,6 +25,7 @@ static int init_vq(struct virtio_pmem *vpmem)
 
 	spin_lock_init(&vpmem->pmem_lock);
 	INIT_LIST_HEAD(&vpmem->req_list);
+	WRITE_ONCE(vpmem->broken, false);
 
 	return 0;
 };
@@ -137,6 +138,12 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
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
index fc8f613f8f28..49dd2e62d198 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -44,6 +44,9 @@ struct virtio_pmem {
 	/* List to store deferred work if virtqueue is full */
 	struct list_head req_list;
 
+	/* Fail fast and wake waiters if the request virtqueue is broken. */
+	bool broken;
+
 	/* Synchronize virtqueue data */
 	spinlock_t pmem_lock;
 
@@ -53,5 +56,6 @@ struct virtio_pmem {
 };
 
 void virtio_pmem_host_ack(struct virtqueue *vq);
+void virtio_pmem_mark_broken_and_drain(struct virtio_pmem *vpmem);
 int async_pmem_flush(struct nd_region *nd_region, struct bio *bio);
 #endif
-- 
2.52.0

