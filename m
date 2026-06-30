Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4F43E95AB;
	Tue, 30 Jun 2026 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811493; cv=pass; b=kNkAKtJyAAJyw1/Fqa624DXUWeWcWG0ct//mfoBRURUR6Ylm1HxgOjPCFw4PwC7rw26H+QXnTniAXi0tVIZ3ekZIgt3XrzokqVcVnpMFRm/PD31Rk85QPs1vZ8ohBEaFza+xDkt/axOAogHHy5yDx+GqHrWjHhHTsaSSI/uVBRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811493; c=relaxed/simple;
	bh=NGzI2chS9Sdc60uy0rEJC3DmOpfN6ER9grhNPstrvng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogUA0XDZqsxMkVBmcwNrlIaZ+0sqg3ZWYaY2mH9LfmX4thhKipj+STyq2t7jWXbypqj/B1IOIJOuKrAl7lVJZFxJhiJO4GQ5S89HlU6le5lQZ8/tKepbtduDPtk3j/bGle5udeU1hlw1HstfKVwkKWpyDqdZMXQNF85gtFIfXSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=GhPHb5cb; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="GhPHb5cb"
ARC-Seal: i=1; a=rsa-sha256; t=1782811462; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=eYULxgsvQowgKRG8JJlsdG/LNM1k0m89ZtBBA3O3y7fZyleq32VG3hVPCt1YOjl5Lokq4x3AZ9+7PAWPp5knvNdeG/m09UG7lAq9xLzXyN+CdV1vlu1Q1LOJ+IywFhZ6wUdSEZMO2iJ2G4Fv82Fl2uZr4tbEF81sQ56Jq3SVeDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811462; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=BI/OWAyEM7MVhqasXsMykwzNXsGFC80gbjIFYMmavWU=; 
	b=R3Y8AXPi3cn7e27oaSgkYsU4DIWWr68m87yc7QK16A9ZnEBgDXNs7Qup/cvR4M4mdJ590sqyVk9ncMTlsbO9/NdQ61TqNnMw9Tum15d4Y6H4SJ2YYEMZn+aDAbiGsyUxXUVcCyjFdLNl48afj9nOH51sXZMNtu3ovnAAW8MoHV4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811462;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=BI/OWAyEM7MVhqasXsMykwzNXsGFC80gbjIFYMmavWU=;
	b=GhPHb5cb/xf3SOdtmD+mjhMz+ChXZYrE5cBlYPrd9l50TODN2ow4ltr2APwYA/SH
	7BDlTU2OzTwqNhYQV9NppsMrN3idImvyj5RyVKuxDIxfvq7ox82U2T8JjS3zA9hsO/d
	WUn1TQkNG1jls7r+DF7k7TsrY1KjBk2XMlYve/OE=
Received: by mx.zohomail.com with SMTPS id 1782811458619730.5904022253595;
	Tue, 30 Jun 2026 02:24:18 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 07/12] nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
Date: Tue, 30 Jun 2026 17:23:32 +0800
Message-ID: <20260630092338.2094628-8-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
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

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v7:
- Add Pankaj's Acked-by.
v2->v3:
- Split out READ_ONCE()/WRITE_ONCE() updates from patch 3/7 (no functional
  change intended).
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.

 drivers/nvdimm/nd_virtio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index fcb26a595d7c6..8c0d4347938a1 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -24,9 +24,9 @@ static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 
 	req_buf = list_first_entry(&vpmem->req_list,
 				   struct virtio_pmem_request, list);
-	req_buf->wq_buf_avail = true;
+	list_del_init(&req_buf->list);
+	WRITE_ONCE(req_buf->wq_buf_avail, true);
 	wake_up(&req_buf->wq_buf);
-	list_del(&req_buf->list);
 }
 
  /* The interrupt handler */
@@ -40,7 +40,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
 		virtio_pmem_wake_one_waiter(vpmem);
-		req_data->done = true;
+		WRITE_ONCE(req_data->done, true);
 		wake_up(&req_data->host_acked);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -72,7 +72,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	if (!req_data)
 		return -ENOMEM;
 
-	req_data->done = false;
+	WRITE_ONCE(req_data->done, false);
 	init_waitqueue_head(&req_data->host_acked);
 	init_waitqueue_head(&req_data->wq_buf);
 	INIT_LIST_HEAD(&req_data->list);
@@ -93,12 +93,12 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
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
@@ -112,7 +112,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		err = -EIO;
 	} else {
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->host_acked, req_data->done);
+		wait_event(req_data->host_acked, READ_ONCE(req_data->done));
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-- 
2.52.0
