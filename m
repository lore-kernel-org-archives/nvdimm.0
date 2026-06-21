Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D291936682A;
	Sun, 21 Jun 2026 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047035; cv=pass; b=IdBGhN+0cJBAh6tAJd8B9nzKJfd1kqaaykzD55VRUAMF/fzclXw3XeCPL1J8C2t5uJRDdqedOeBbayKLwPtcbpnpxefF2mkaU00w5hCfo3L1dAgrgiGt868Jz5Mnzi0wQLiC6fvxt3deAncpymbvwNRRRFBoPP81bTc1ebtF7RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047035; c=relaxed/simple;
	bh=7M9kmKBZp9rRu0tA2yaME8tBtzESVFG0IxssR+73ZAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZXgeJQTXXkzrGZUf8HVtE6e/8x9JMsK9NXsxsvZw6F7XHs0OYRo6OF3boJk68TOC/iwSwf8z41KNddsFgg5PaH+ewKWzWitvoatCxYVgheII2hrPOz8c/PX2P0uArF4hcoiUHBhGV9WQDC48hPaws255A9jKvMZRUx3HFF0RmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=EFmv781H; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="EFmv781H"
ARC-Seal: i=1; a=rsa-sha256; t=1782047016; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=f9E9qvTYWBNIBDkXm6fgw6tSiaHY/GxLNBJ03Uj9UiPyJPbXyjlv9phHJEYJvsBiLbg82GgVS5wJTZXmM0SKEzkYOpeG5XGID2DVA2Az+cxuXpBLIhJBeu4UKFWrr+7+OBwE4Od8ymL+orH+F9TtOdtm4BIvDqC0KkZGVSJjlrU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047016; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LZLBhHbmtjpySzZTarBL23J3mQcNrZwkvgLBIJ78RGM=; 
	b=bAlad01sDqx1GLmgptCqPp1NLsmH+y41m3zan5lt70cBWIFgxgYg/mkrIcuIufj7JKkYLHqgT9lUzY0Pu4vPRlZkxA7UBYAiyOSm4tqSt52GD3dFAt2iMZ5dad7g9R2JARjxq6v1eY5mDi1QcOAdDGrlxVwY86NHsJ7SlpMwioA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047016;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=LZLBhHbmtjpySzZTarBL23J3mQcNrZwkvgLBIJ78RGM=;
	b=EFmv781HFfJZxTBIGc5tZUGUme4fRFChURsdzCnruo146STntdNbJDjOoLv5fwW7
	vtM5gyRbD2Xnwn4ydJD/c5ZUe5rExCE2vlWfhPCpxUxlXiEz8YlZmhIedOfcg4LBfPR
	S7VUGj5aFDr5Y51D1uvCRSXM7T7mHquUEi+1b6sQ=
Received: by mx.zohomail.com with SMTPS id 1782047013626864.9869101777588;
	Sun, 21 Jun 2026 06:03:33 -0700 (PDT)
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
Subject: [PATCH v6 09/12] nvdimm: virtio_pmem: publish done with release/acquire
Date: Sun, 21 Jun 2026 21:02:40 +0800
Message-ID: <20260621130246.2973254-10-me@linux.beauty>
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
index 7b6761adf28bc..35d36bd36a526 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -17,6 +17,19 @@ static void virtio_pmem_req_release(struct kref *kref)
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
@@ -42,8 +55,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 	spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
 		virtio_pmem_wake_one_waiter(vpmem);
-		WRITE_ONCE(req_data->done, true);
-		wake_up(&req_data->host_acked);
+		virtio_pmem_signal_done(req_data);
 		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -130,7 +142,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
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
