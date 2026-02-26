Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56C43815D1;
	Thu, 26 Feb 2026 02:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074664; cv=pass; b=Fip/SmZBbB4iMwrmDDtVaFpr2WU5ob7xyEDv2twCWS2qxeWg7ZJ3K8LUxKdLXLyWywFtY8iM7nuvP/10+KtmQBQ/fRhgxRmGRSoTJyTbSoApKUvtd2vjREWjuTkqqrCrF01ST16jzz4F3dawtT22SnX1bzogoFSdRQBeYlppg6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074664; c=relaxed/simple;
	bh=FTPzy2Ja9TzQHUhKRmFBDjXdPOtdEpZol0MHss4wVN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osFGQBuHutddboQumpElUgiA62IqoCOKx+sUNT64HcOp9TiYXczyOW/3dHNfiKdsM6W2Ykcokpa6T3q0rJUHbwuIaB9/5Y/moJMAjE2+GxjNLm4El24Uk6G00NaIekGOxEedkzysygwbVyCIJhM6VM/BAU9XYMOKRNCJYxqApKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=erGro9/h; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="erGro9/h"
ARC-Seal: i=1; a=rsa-sha256; t=1772074655; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=acwNJF8ZV+lMkKhv6RY6RWDeI2hEnkgylVAbLLRZnq/+GBkwwwm0rXKc0v7oayIvQSPnIrRxNPFNseH91TWcBFMCvDI7Q23X5hfX28qS/pAEmoDUC0KpAJMG9nDnuqqeeNU2OHqpBtkZ3LsBNkbAz3SiR5+btg62SlgmAEl9UoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772074655; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=YYgP/LCldFwD04IaoaUAa6Vhao4j048xK5R4cG9FPOg=; 
	b=aOtpJzpAVllEVjiG3jlUgYuzVo07blmeTEs0V+YJDfEawkGcnC+7kv4lIUVU++QhJvOpiLKFAxmJgmdYfHYGa9iw7bDto0f21lWTFx5M2gJhZNwoYFui2qX+jQOLGy/fyDHsDegMfOju1vBj6lJghjA8z6TsWGatWhoR2OvzD0A=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772074655;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=YYgP/LCldFwD04IaoaUAa6Vhao4j048xK5R4cG9FPOg=;
	b=erGro9/hNOh1zjykjUsw2nB9n1AwEZiUM0p6gqPSiRyA6yo2h4/r1YRDnFJRFqFn
	tQwFdhhw3o16wZYMobLfr+Mg88wTZuNQPFrAoPbIU4u/7fcXdKomBhjdxVV1Nzi9hq5
	VYlFL4mrAj4zUW+OFGhnp6SxgUWO0nt8D4hl5Q+4=
Received: by mx.zohomail.com with SMTPS id 1772074653879983.229166346284;
	Wed, 25 Feb 2026 18:57:33 -0800 (PST)
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
Subject: [PATCH v3 2/5] nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
Date: Thu, 26 Feb 2026 10:57:07 +0800
Message-ID: <20260226025712.2236279-3-me@linux.beauty>
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

Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
wq_buf_avail). They are observed by waiters without pmem_lock, so make
the accesses explicit single loads/stores and avoid compiler
reordering/caching across the wait/wake paths.

Signed-off-by: Li Chen <me@linux.beauty>
---
v2->v3:
- Split out READ_ONCE()/WRITE_ONCE() updates from patch 1/5 (no functional
  change intended).

 drivers/nvdimm/nd_virtio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index a1ad8d67ad2d..ada0c679cf2e 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -18,9 +18,9 @@ static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 
 	req_buf = list_first_entry(&vpmem->req_list,
 				   struct virtio_pmem_request, list);
-	req_buf->wq_buf_avail = true;
+	list_del_init(&req_buf->list);
+	WRITE_ONCE(req_buf->wq_buf_avail, true);
 	wake_up(&req_buf->wq_buf);
-	list_del(&req_buf->list);
 }
 
  /* The interrupt handler */
@@ -34,7 +34,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
 		virtio_pmem_wake_one_waiter(vpmem);
-		req_data->done = true;
+		WRITE_ONCE(req_data->done, true);
 		wake_up(&req_data->host_acked);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -66,7 +66,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	if (!req_data)
 		return -ENOMEM;
 
-	req_data->done = false;
+	WRITE_ONCE(req_data->done, false);
 	init_waitqueue_head(&req_data->host_acked);
 	init_waitqueue_head(&req_data->wq_buf);
 	INIT_LIST_HEAD(&req_data->list);
@@ -87,12 +87,12 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
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
@@ -106,7 +106,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		err = -EIO;
 	} else {
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->host_acked, req_data->done);
+		wait_event(req_data->host_acked, READ_ONCE(req_data->done));
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-- 
2.52.0
