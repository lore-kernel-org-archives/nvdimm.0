Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8DF2F0C63;
	Sat, 20 Dec 2025 08:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766219707; cv=pass; b=DHkZa++iijEAquTeTaYqhY7UV0yGyCL123O27iYoipXqzVY4uibOw2FHZPqkWCK/RFAcg4IFFDOpaC/KJMwhx310YLzk2sxaWF0lffbj9uq3Ec+qLiCwzt9cFlYkBqgW6IHWDDvsFsE2LsUN+gZWazNzJ7/O6jlkZHZrR0lahH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766219707; c=relaxed/simple;
	bh=wt+gTUC83JZ2Aq1RqnhRNClbtK0fIj9oGNFDYzmLP6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slid3skKs1Hl1roXSXSyNhuLl3wqFGVTF4zvD6/vbMRlfO++7IblSFvqWaflZrpzNsSf+NH+7B/ooXj8Vya1DDFAbHlaAHVEzB+yuXnQW4YOmCdxHzJGWvWXuLoJybaWnaoj6Go4+IlBB/CTeW6OYs9PgZ18OwRA+GXFXen20l0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=eANzaIgm; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="eANzaIgm"
ARC-Seal: i=1; a=rsa-sha256; t=1766219698; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ndbPvrkOuOd6KqefsIWqYKNj9xAq6YAJcmF9gQSSGhl3aGnCb/r7QdIhTcoA/qZZ5oRR39qIXKpAgBTZIR+46GpWvb9O1swT1zzmbnr0XSb9y1484FPQOfwftUE0WRaHv1qVg54gAW0+wHc8rmDuWdVHzeOwUMBVsw4TD2ZLjFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766219698; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=MLyXrglSwdiqLX4MJciWPiqlZQ2ZHYVwKNHsXrftGsY=; 
	b=Vh+RdB5qtCPFBSkpyKWPLdG5X81UI3TNlcYFLzTfP+xse+VYlZ3KHGsO6b79r/5MlPrWjIFk2yyumOLUZ3q4CXhfn8DaR0JNWfvOA6wCYVMlG5MVP3bZWDuhY5Y1jZe0z8wjg+NRdQXYxs1KwB1N1wFHt2n8VAO6iNYRNeh1BH0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766219698;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=MLyXrglSwdiqLX4MJciWPiqlZQ2ZHYVwKNHsXrftGsY=;
	b=eANzaIgm7w1fTQCFR67PWg6vd91MfzcvcWUU84Jz7H7giijC+/Tn1jMyGSpMkbKj
	q1RK5+k5s57DQT+8u7HVs/qxLyr/s1SDMkxmRL0nXOJDittARnT7J8E9FKQCOkedj82
	fWj8yKlIFzD4hbOfISkUXTP7l61MSWIrMpI9cDes=
Received: by mx.zohomail.com with SMTPS id 1766219696031997.6480453791337;
	Sat, 20 Dec 2025 00:34:56 -0800 (PST)
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
Subject: [PATCH 2/4] nvdimm: virtio_pmem: refcount requests for token lifetime
Date: Sat, 20 Dec 2025 16:34:38 +0800
Message-ID: <20251220083441.313737-3-me@linux.beauty>
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
2.51.0

