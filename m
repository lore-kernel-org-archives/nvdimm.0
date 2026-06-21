Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F0E353EF7;
	Sun, 21 Jun 2026 13:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047049; cv=pass; b=mZMmCQRaI60TOyXewlVB6G3wwnE5ecoQm2xwUOqo313Jxe8mArPLPXni3cQWT5yezuUuyh6jI1trw/alytNUlS+9juk8rEMpwTAM87RXkUMVPxtb9w0bs9mLmgyYc7f41GqLLW+GOaZl4VwI3/vD8RkfhYvjSbkbhEWQpoQIcEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047049; c=relaxed/simple;
	bh=6A9bWkf8F7xrUAnVlnOMf683ur53Qgpma7ZseFnzL+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzJ8OxUP7BjpWXDPMqjl2QLUVB6G1d5QrCvGygUxzRElWeB1yUb7eYrl7ZOZYP1I+j6e78d8/bLlITP4MMohjqA82t2QUKS49CRBQz/+bLLAuaZ4ddVrSjuue96K41Qn1iOexoqI3qP3vTGX1Kd3XoGLrUsMB5urMJP85Xhdzs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=EG3c/+KY; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="EG3c/+KY"
ARC-Seal: i=1; a=rsa-sha256; t=1782047026; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gnmhKO7qHPV2bZVslIlMV9Qkik4X581pkAUerMN9G6E8eooGvcRJu1TpGeBoEu7mFxJ2a49iKbHCI9HPKV4r0fbwg9PzlxAR2e2Lrspu75BbQ0CAF4BN7A78y7s68W6h2xTKroIjnCs2elKjuQDmGQjZhPWvTaGo+hKLMbMxCIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047026; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+WTLNJnsHO7DCEChsDnpLBkOw/OLyz+oCtQwOwb1Nvo=; 
	b=BW5SevhwVLkI1gZmXuObn9topz2pUxEYTlUkgrTtgoYGLVWKIAWB9lSv/kXSLkaP1DueHLV0JXf+wvbWxUT105uGv9OVyzfZqYGoZft45jq/d1nttc7qgr7Ds0z9Ea5zOrMVIgKp9x/CTyU2PlQfhtzD61dLxh5Xhjrd4hBTXjQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047026;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=+WTLNJnsHO7DCEChsDnpLBkOw/OLyz+oCtQwOwb1Nvo=;
	b=EG3c/+KYzqyCPkV1fWwGBj2aDC405wJTIJhIJVGYAO/O6vn3hhaL24+zbWW/gsjp
	7eW7EKu9gq4xnLN5gPNGktzkEyBfL4v3raaSZY7X9NRnfOWRSmveEVt7N/UrCJdaccA
	4p47FD1LdP9iueHkj5U8hI9WUmKLe4hHwBfGKN30=
Received: by mx.zohomail.com with SMTPS id 1782047024089538.331592221489;
	Sun, 21 Jun 2026 06:03:44 -0700 (PDT)
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
Subject: [PATCH v6 12/12] nvdimm: virtio_pmem: drain requests in freeze
Date: Sun, 21 Jun 2026 21:02:43 +0800
Message-ID: <20260621130246.2973254-13-me@linux.beauty>
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

virtio_pmem_freeze() currently deletes virtqueues and resets the device
without waking threads waiting for a virtqueue descriptor or a host
completion.

Mark the request virtqueue broken before reset. This makes new submissions
fail fast and lets -ENOSPC waiters leave the wait list. Reset the device
before draining used and unused request tokens, then delete the virtqueues.
This wakes waiters with -EIO. It also keeps the detach call on a quiesced
device.

Clear req_vq after del_vqs(), and make drain tolerate a NULL queue, so
remove after freeze does not dereference a stale virtqueue pointer.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- Clear req_vq after del_vqs() and make drain tolerate a NULL queue.
Changes in v5:
- Reset the device before draining used and unused request tokens.
- Use the split broken-marking and post-reset drain helpers.
v2->v3:
- No change.
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.

 drivers/nvdimm/nd_virtio.c   |  3 +++
 drivers/nvdimm/virtio_pmem.c | 36 +++++++++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index fb9391ebc46e7..ce4032dc07628 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -93,6 +93,9 @@ void virtio_pmem_drain(struct virtio_pmem *vpmem)
 	struct virtio_pmem_request *req;
 	unsigned int len;
 
+	if (!vpmem->req_vq)
+		return;
+
 	while ((req = virtqueue_get_buf(vpmem->req_vq, &len)) != NULL) {
 		virtio_pmem_clear_inflight(vpmem, req);
 		virtio_pmem_complete_err(req);
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index b272e9279ef23..fef792f725db2 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -17,11 +17,16 @@ static struct virtio_device_id id_table[] = {
  /* Initialize virt queue */
 static int init_vq(struct virtio_pmem *vpmem)
 {
+	int err;
+
 	/* single vq */
 	vpmem->req_vq = virtio_find_single_vq(vpmem->vdev,
 					virtio_pmem_host_ack, "flush_queue");
-	if (IS_ERR(vpmem->req_vq))
-		return PTR_ERR(vpmem->req_vq);
+	if (IS_ERR(vpmem->req_vq)) {
+		err = PTR_ERR(vpmem->req_vq);
+		vpmem->req_vq = NULL;
+		return err;
+	}
 
 	spin_lock_init(&vpmem->pmem_lock);
 	INIT_LIST_HEAD(&vpmem->req_list);
@@ -31,6 +36,15 @@ static int init_vq(struct virtio_pmem *vpmem)
 	return 0;
 };
 
+static void virtio_pmem_del_vqs(struct virtio_pmem *vpmem)
+{
+	if (!vpmem->req_vq)
+		return;
+
+	vpmem->vdev->config->del_vqs(vpmem->vdev);
+	vpmem->req_vq = NULL;
+}
+
 static int virtio_pmem_validate(struct virtio_device *vdev)
 {
 	struct virtio_shm_region shm_reg;
@@ -132,7 +146,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 	nvdimm_bus_unregister(vpmem->nvdimm_bus);
 out_vq:
-	vdev->config->del_vqs(vdev);
+	virtio_pmem_del_vqs(vpmem);
 out_err:
 	return err;
 }
@@ -154,14 +168,26 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 
 	nvdimm_bus_unregister(nvdimm_bus);
-	vdev->config->del_vqs(vdev);
+	virtio_pmem_del_vqs(vpmem);
 }
 
 static int virtio_pmem_freeze(struct virtio_device *vdev)
 {
-	vdev->config->del_vqs(vdev);
+	struct virtio_pmem *vpmem = vdev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_mark_broken(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
 	virtio_reset_device(vdev);
 
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_drain(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
+	virtio_pmem_del_vqs(vpmem);
+
 	return 0;
 }
 
-- 
2.52.0
