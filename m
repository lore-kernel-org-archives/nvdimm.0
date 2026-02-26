Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB343815D1;
	Thu, 26 Feb 2026 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074659; cv=pass; b=oJKRF7DvPt4SPTwRqKQgP0FbVDhfTiS5rn1Nwf0Yh1MQu5UEDRl60/1SRLmZxVyOVs2WOf4WXcZYMDOIO4ZldxgSmb085I0yHEQjyZrVHY7ARKVtYUhJVMCVkO0eLUYrPZS53kCB2BSsvTLHK5TjOQrMKL7ovVZckrw+G2TxvRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074659; c=relaxed/simple;
	bh=G5b72HfKWuXYwZ6VlnHYS1xuLZTAW5LrQw5mObxUPm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mASStEulyjg8WA7iece6y6F1HwjMxDsQ8Df7k84TeZJOFhy6iSDTd1KzdjnaWWmfPiHrXEFiUIPs+Ru6icIuaOPpD7WYP78+9iYSxLBORw14ErZJf7N8DchcB0Qpno8+X2gd3WDepEBRrsoiW0EsVEWRbsf5FYHYCAXD1mX+0dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Pzp+aac2; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Pzp+aac2"
ARC-Seal: i=1; a=rsa-sha256; t=1772074653; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fe1e9zUixitXwPn64G7HAbbul6e/G2HOnMq4Fp8AVQKeCQV9yBruYUmFJK4nmvYeijOWNqRlo0y2D9nR+sRrObHC3eGhPCe0p+uG30w1C/CoqoRE21eLO6RbaUlhyIUOb5QRlgTemfM/ZCTh0+h2jx8JXGfW7cCTczmLC9NEhiA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772074653; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=NGwdvopqV5dpjItLDiwWZsiiVWpt8I+LlteAlx+Vpso=; 
	b=L9GfOtsJNTDkTk5fzoVfoYPvDoatpEb60TvsjUtRFbhrYV+Nh6hIhV0M9TcSSVKYGt2CgpnDfGlNzGMlx6IMw/4fKsCTetJ6278X9Cr+pOoEChuGq2BG4cf2V/0C3KcBI3AIbKPZlWF6+pVVomggZYgVazkplAG8iumfd0Ajmi4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772074653;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=NGwdvopqV5dpjItLDiwWZsiiVWpt8I+LlteAlx+Vpso=;
	b=Pzp+aac24AKPxNy4ykwRT7p/B1a5E3ZH9Cu1jfUwFW8v4Wx+bnihRaPfaS20xoSR
	Eztx6R9tA86fnw5vNwiuhy47EvUBy0g+PV7V+drUT9dcWzj1n6zEEmhrN6NCVvFxj80
	OU8otqcWvpuY/htODiL7JuBlPGFd5K9Nev7mRrbE=
Received: by mx.zohomail.com with SMTPS id 1772074650605524.6827548090777;
	Wed, 25 Feb 2026 18:57:30 -0800 (PST)
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
Subject: [PATCH v3 1/5] nvdimm: virtio_pmem: always wake -ENOSPC waiters
Date: Thu, 26 Feb 2026 10:57:06 +0800
Message-ID: <20260226025712.2236279-2-me@linux.beauty>
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

virtio_pmem_host_ack() reclaims virtqueue descriptors with
virtqueue_get_buf(). The -ENOSPC waiter wakeup is tied to completing the
returned token. If token completion is skipped for any reason, reclaimed
descriptors may not wake a waiter and the submitter may sleep forever
waiting for a free slot. Always wake one -ENOSPC waiter for each virtqueue
completion before touching the returned token.

Signed-off-by: Li Chen <me@linux.beauty>
---
v2->v3:
- Split out the waiter wakeup ordering change from READ_ONCE()/WRITE_ONCE()
  updates (now patch 2/5), per Pankaj's suggestion.

 drivers/nvdimm/nd_virtio.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index af82385be7c6..a1ad8d67ad2d 100644
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
+				   struct virtio_pmem_request, list);
+	req_buf->wq_buf_avail = true;
+	wake_up(&req_buf->wq_buf);
+	list_del(&req_buf->list);
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
+		virtio_pmem_wake_one_waiter(vpmem);
 		req_data->done = true;
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
-- 
2.52.0
