Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC273EDE6A;
	Tue, 30 Jun 2026 09:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811488; cv=pass; b=dDNXwF2zebF29j6Ezm9hBKo3uC+phfI8GpyWTMCZdBdHai4razDVt0FKFwgXvYdz3UAUG0uYUkUNiCo8UyfFyLBb3EOaYJ7zA+vQZshpd0i2rUFL2rpFs/O7ZcdhQCXC+omhsWlp8AQhBXENyWjLF5bJKJ1Ax0HuHDifhIt/ko8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811488; c=relaxed/simple;
	bh=hd18FWLb1hcER0eGN0CDNYzR1McHOJM564y1QUlWJmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtewIB7jO1HX7fQDctqTdM3rA3JQSFVTC72HJwvu53NDWHKjXwiXIudTLMrZ2zSXYcn+jabBY3PcghGIvMEKcH927NU+BecU4uNVtY4XAEgwntUS9wajcjQ18HhByWxlbIfQbgEOzE8ZmiflhF1GjNiXPg3ThGBRy45TWT6ub4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=RR2K/AEH; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="RR2K/AEH"
ARC-Seal: i=1; a=rsa-sha256; t=1782811458; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=j6vtgyyidvpfh4yzjBIDMs5mOJAKY75BgwtRI2LDH/HA0UPV9N3EVykPW/cIpkSrcfTl08cxZkyw9sgK0DLocqXW7D3jbzgkB6vL8HEPBgecJSz2TVLBexGQ9bQ8Dq/VoljQCoQNawZCwA/ylQyITiceJ2TngW4YPzxWLqwCB3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811458; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=cV4ALsu3V/Afm3yHy+Bf/CmLmsd/Z4GOKtaXkbRgoWk=; 
	b=GjdsKrYjH905os0InRouB9nPwKhtti4oMsjHdbjLVYWryMI1fiMna2m8bMJo0D/n1r++7LpCJiBC7rP2tEP2mOmsfVWAloNI0tasqZITxqtiGWCDKkTtvk7Bd25tyKlmBBxFVeh26SkI0mo+c3vnHLmOcMGg/38ILqgoE7c+LTk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811458;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=cV4ALsu3V/Afm3yHy+Bf/CmLmsd/Z4GOKtaXkbRgoWk=;
	b=RR2K/AEHiJ4oSAvOUtieRYacbkQ9uu9kx0b1u0GQLhDoiqJwDrVoWNJf5P48M2ef
	ERUiyQKPlWWNSYKl+ySKiHyrkDLBS5ahMlC8PFbPTB/VZ5nPXzRWB4YDxSpLHTo5O4z
	FdS0owk7i1tGqQ0bSlpTeXrn9Q8B872/zHVkGJp0=
Received: by mx.zohomail.com with SMTPS id 1782811455428174.18424278975897;
	Tue, 30 Jun 2026 02:24:15 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 06/12] nvdimm: virtio_pmem: always wake -ENOSPC waiters
Date: Tue, 30 Jun 2026 17:23:31 +0800
Message-ID: <20260630092338.2094628-7-me@linux.beauty>
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
  updates (now patch 4/7), per Pankaj's suggestion.
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.

 drivers/nvdimm/nd_virtio.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index a35044afddf34..fcb26a595d7c6 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -15,26 +15,33 @@ struct virtio_pmem_flush_work {
 	struct bio *bio;
 };
 
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
