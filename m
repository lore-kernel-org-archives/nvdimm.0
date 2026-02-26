Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F293815DF;
	Thu, 26 Feb 2026 02:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074685; cv=pass; b=D/OBiR8e3qUTsCE6bv6Xge/ROhu2RjjasgQphlI3nLyrVuVoQwpqMvMTwUKzSuV5CxMxJnKvuSYO3s8qvfNBV3xYQCatHqg+3yOxo52gSO7fAznXpMbS/5i16gdgKcS4fbohZPT5E3KRsulz7V62IkYMV9dVLu3o0dQE9hiTHX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074685; c=relaxed/simple;
	bh=eVpgaiBDEYmba0hqSGqHQNqluD5rnt1oRmsHZ330I00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf33CsMYq3+TeIAFgPJOu3+N3JcJEVXZ6/CxkSnxJ9E5O6DXCAhG26h3aVvsgSSo+iuBrrTswP0Dm/pMgZqMwuI6Hwn3bL6rrr+7SndKvkI3Zdppzh2lhwwPihNwjery/dR3/U5z4eaNHC3dnvUxYj2nvyotVONoX+tuw4bl2fU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=EuzQAdEW; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="EuzQAdEW"
ARC-Seal: i=1; a=rsa-sha256; t=1772074667; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QWIL+eIQjcosYxbebQaCHtCc8qCSVvBPDOqwJQYq30OV6oucvIiPxYLbus7+kMF9S0Tw64Cz5+ffZxkHeKNFM5IbACNi/sxKa0Hnxa/Qz3qJrdwGtTefStIHuyFfcGwDVTvKFYRBsmQgWQxqor2P4zDlBWu974ULWluzx2zI5rQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772074667; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=oFwoQ+E7tMKE0RtYZZOdoKWdlkJ/ai0zXONzCJDDN3w=; 
	b=gP+j7lr/Lu4+MXNAXyYVEnCX6At6hpOY88ga8QtQUkdcmafD97oB/0wgdUKZgfgm1Y72DYzzVWqBHn6j2BE8lf6zq8LJjr17n+EmeNGUPfoMXdKq662/tFEOYFpJUtMKh0f9mKsFX/p+NI0sYUsGUwiVvihEPKWRP9qi6gcwXAI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772074667;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=oFwoQ+E7tMKE0RtYZZOdoKWdlkJ/ai0zXONzCJDDN3w=;
	b=EuzQAdEWmvz5IK3WEoAMl8JaNB/8pGwe76h6EPlDK+6CSu3wzvgw6hz0e18Te/av
	dXjeHAX+KCJt1UyayYiGa/xVaeUVTypJgw5TQ4t1bOHdFwub7rdHjH5z4SJNXgkEF3b
	aCIoHF+F8WLBGMn1mrfYNd7u94Py+OTEA2sgHTtg=
Received: by mx.zohomail.com with SMTPS id 1772074666061797.0908931346248;
	Wed, 25 Feb 2026 18:57:46 -0800 (PST)
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
Subject: [PATCH v3 5/5] nvdimm: virtio_pmem: drain requests in freeze
Date: Thu, 26 Feb 2026 10:57:10 +0800
Message-ID: <20260226025712.2236279-6-me@linux.beauty>
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

virtio_pmem_freeze() deletes virtqueues and resets the device without
waking threads waiting for a virtqueue descriptor or a host completion.

Mark the request virtqueue broken and drain outstanding requests under
pmem_lock before teardown so waiters can make progress and return -EIO.

Signed-off-by: Li Chen <me@linux.beauty>
---
v2->v3:
- No change.

 drivers/nvdimm/virtio_pmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index c5caf11a479a..663a60686fbd 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -153,6 +153,13 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
 
 static int virtio_pmem_freeze(struct virtio_device *vdev)
 {
+	struct virtio_pmem *vpmem = vdev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_mark_broken_and_drain(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
 	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
 
-- 
2.52.0
