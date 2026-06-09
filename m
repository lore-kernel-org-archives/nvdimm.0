Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A287C29B77E;
	Tue,  9 Jun 2026 12:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006944; cv=pass; b=ufBYKb+AgDsOAL8uETdTTt83qPJ6nZ9eghrl1HS08jUBh/vWw7J9/24Vz2c5rb17Y357/mtHlQYZL79N4Xcgy4Jb8HcdHhx5NS3WxzrZm2A2ExLERGDsu1KLadqSCtzxnBYE8iggEw0cWA2Yrm+H1VqKlSMCNGADRYtOfeIrCRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006944; c=relaxed/simple;
	bh=bn3S0f6hh68X/Oaw8Hh6vZHSDp7Cai9WzOE3QKPHnYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plemiW7I4QBSZSfoyBKbM7QOR86e5YKQcpbeNtoz+meFjyCVMGIL5qnEMYW7Ob0sfHr/y+H9EMe5mFBEfHZTX8o2GADc0l6ROpE8qgI3hb7Dh/qwAvDII+yiZ4IVhSzmD00HZ/OelIKxn+G/MELvUTYjFrMNLD6JFOBqpDIPu3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=JTAYfqlu; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="JTAYfqlu"
ARC-Seal: i=1; a=rsa-sha256; t=1781006899; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=AfKYjOQgbxwfglBIKNPmi1ko/0vOSrZe7WyU2RBVBT6QDI0s31UGmdnZmwK+rku/I3f4P78fOpl8K8ERRs2m96R1P2aTcWsZVo/kMQk0VOCFgx+bXhh8wm4xjzMXRXXk6i0ozsFE7Q6nFu7XaDmIMyEA1Kv+XaK0qFv13g9T6j4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781006899; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7ESR/E7bBpudii+D5llqF8/d9qpr/9CdW0jpPzvDoGM=; 
	b=dE/cB2ZW3IUbkH9OnhgOshoRUPSbEWAX3AqMMKmX7sUgj4X/tfnd2i3ZkCaxAarTzVucE39xTYNY+enhrQlUYRqtfDbGgJsbD3Epd+4GB/jgMkgTb3GTuCCvXwoDBJTjayA/bTFz1MempvGHCCTgM+5X/yD1/TUidDZZOyIkjsA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781006899;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7ESR/E7bBpudii+D5llqF8/d9qpr/9CdW0jpPzvDoGM=;
	b=JTAYfqluJbzbRgalGDvPptxn3DDcOZO6QiLMBas8aqncxyhTO/no17Ohqom6wDDn
	4Qv6skxLNu5szEayRPim75a43rtdrW38AaLLtg7X2yLct5akS/kNAf1fR1EcpLBJQ7W
	MqcxZ/dCV9gMBab0A7ecs0G3xlVAGvPPvoM9K0Wg=
Received: by mx.zohomail.com with SMTPS id 1781006896109750.373420175094;
	Tue, 9 Jun 2026 05:08:16 -0700 (PDT)
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
Subject: [PATCH v4 7/7] nvdimm: virtio_pmem: drain requests in freeze
Date: Tue,  9 Jun 2026 20:07:21 +0800
Message-ID: <20260609120726.1714780-8-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260609120726.1714780-1-me@linux.beauty>
References: <20260609120726.1714780-1-me@linux.beauty>
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
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.

 drivers/nvdimm/virtio_pmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index c5caf11a479a7..663a60686fbdb 100644
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

