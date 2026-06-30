Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB893EA96A;
	Tue, 30 Jun 2026 09:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811504; cv=pass; b=m+C3CJ6n59LZl7BIUOfjRanmeE1gbu4l0qxhzgwvzUpK+M8M9B6BcpUxLZ+zdzso3uykC6CTNRWwW42qR+KNZQbqxr8I/o5d0FEtbEkFkcRJf/Ts8J5O+jjTbfa8N012/7D/CRcmplP2bbp6bU8H7KvkjVhqCgkZe2pgBMSJYGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811504; c=relaxed/simple;
	bh=jiMBO23GFiWOPc0+flsdR/RSSDEm/BrgbsoC5qh8NFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvOez+ryylycXMqPHeo3B+eAzaL2tAXoebT5rnU/NUc0vpH7BQKOMzXrXu3QA56XPD/rXjGttmQFTX7SGkyRsZsOQ5mof7hSh1XG4SHbkSmU6PnYDtnBNrfMVpW2d6D+GQ2wQoeiZVl/AdJIUEHBaxPjBjAXef+mnCzETmn64l8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ZsrN4zCc; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ZsrN4zCc"
ARC-Seal: i=1; a=rsa-sha256; t=1782811468; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hVj29vXmSJBIc2LTLm9p050l9b4oxPyHaRsqpL367+OObWGuRn58M1FL0JKaXE324RM3CCoxNzHJUmpjh9IQhUIsDEEkXnmNRFFUAFypZlIh13NljMtenkVx7ZtER2hHUFsni1BpR/flA7fZyu7cyM2LNmPksyKc/xMsPe+k9Ao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811468; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=1OttPtyFARlK/uhLzfs0xf1rrAI5BKBV4NzbkT3H4oY=; 
	b=YNZEMWxF+cCFgzKuZ4kj1iiWRVAquTfyLKNbKPiPpKnG/aiPTAH/sFyDOLBWDVR2+wY8KW5Sa6U289tkPCyE8KsiZYWXy4cVmWz0qFFMOW5zrUF9uz9682QrPVv8ogUR6qNJ7OSnv3ghAbl+D44WvlbThHj1rPXsP8jLqB2op64=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811468;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=1OttPtyFARlK/uhLzfs0xf1rrAI5BKBV4NzbkT3H4oY=;
	b=ZsrN4zCcGD6yAcbCh15YVtlXijQ3LPTGWhoRaeuw292VZ6x3gSJe26g5bBDtlpw5
	SUpwXXmxt+tZVw24mOwtQR64Ag3NjGw3hSc5q/n9vH3Rm4Su7XFZ5ODJwN81L6K7rm+
	8s1nvqgjaxHEwahrs9qIgyahLXeMjo9V8nqdRJ3A=
Received: by mx.zohomail.com with SMTPS id 1782811465982313.1890715947351;
	Tue, 30 Jun 2026 02:24:25 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 09/12] nvdimm: virtio_pmem: publish done with release/acquire
Date: Tue, 30 Jun 2026 17:23:34 +0800
Message-ID: <20260630092338.2094628-10-me@linux.beauty>
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

virtio_pmem_host_ack() publishes the device response by setting done and
waking the submitter. The submitter reads resp.ret after wait_event()
observes done.

Use smp_store_release() on done and smp_load_acquire() in the wait
condition so the response read is ordered after completion.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- New patch.

 drivers/nvdimm/nd_virtio.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 1cf53f75b1281..e4e4284ae19e5 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -23,6 +23,19 @@ static void virtio_pmem_req_release(struct kref *kref)
 	kfree(req);
 }
 
+static void virtio_pmem_signal_done(struct virtio_pmem_request *req)
+{
+	/* Pairs with smp_load_acquire() in virtio_pmem_req_done(). */
+	smp_store_release(&req->done, true);
+	wake_up(&req->host_acked);
+}
+
+static bool virtio_pmem_req_done(struct virtio_pmem_request *req)
+{
+	/* Pairs with smp_store_release() in virtio_pmem_signal_done(). */
+	return smp_load_acquire(&req->done);
+}
+
 static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 {
 	struct virtio_pmem_request *req_buf;
@@ -48,8 +61,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
 		virtio_pmem_wake_one_waiter(vpmem);
-		WRITE_ONCE(req_data->done, true);
-		wake_up(&req_data->host_acked);
+		virtio_pmem_signal_done(req_data);
 		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -136,7 +148,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		err = -EIO;
 	} else {
 		/* A host response results in "host_ack" getting called */
-		wait_event(req_data->host_acked, READ_ONCE(req_data->done));
+		wait_event(req_data->host_acked,
+			   virtio_pmem_req_done(req_data));
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-- 
2.52.0
