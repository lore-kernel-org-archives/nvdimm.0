Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DF33EA970;
	Tue, 30 Jun 2026 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811508; cv=pass; b=VidlR8d0U418hwk8RlxVJc/MIcCPAiX8OWo4IN/jRaJ7dH4XDpAPpJh9U85a8KaI7GKzJfAxxMgJuZ2hGfRYqwxwqwS40H7BpoHDone7JnXcEuLIaqhumOxsI0nuAJhj8A6sycsyrtv/fjiPLLMT9/j0HtG4ETB5PC9m31oe8wM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811508; c=relaxed/simple;
	bh=x8epGCr0jUISj3HPejgYCvlQvm+Nk+4/t5kEnbaZSnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRYZOHcrsxoZB2k6XgyxPOl7zKMf0jk8C4q/oq4PsSVWZxn2KJ86nq5c5LiqIV/1yF2YgcKRkPC3IKEHMfRsTneGEwWYi4nt5Oit6Dh42T7gbP9Wdags/6xVVfOOg2EMdK1qG0k3Ht8+hPyBc76GTT95AI6zMq2UxiJmdzP2Q7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=pMv4qJwH; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="pMv4qJwH"
ARC-Seal: i=1; a=rsa-sha256; t=1782811472; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Lkx9cSHU8rploUAzKk+0S4FwGVnPy6J46m+YPV5f4tusNCAuAtwdAv3tcoLCEAubkZkC7XJFoHBwWWv/MvTeXDmDSFveBuuq0suedX+Ars+B+eUzOarmgrTqSIfW/C165CQiSyZI0C4OFog2oBeE/1nYMdEbaJkb7YOGo7g/ZGs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811472; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=aRV82qewGWDKaO/i9Y3FGCk+YS/BH0snTkKftmsKdgE=; 
	b=H61kWuoM3DGe7yJKlmcPh1M5mZxPXLx98xJn4TCSDqn0W1rjW4+FXLrhOWM61L7fadYflSPgX9P2Psauf2IcASkbNg8+x0r+J/FuHQSjR/TZ0dzBqEwBEHjWQjniFilPR1Pu+jbalFwqeP81F0yt4IRDKj6n3DYSxKHzH6iDlt0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811472;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=aRV82qewGWDKaO/i9Y3FGCk+YS/BH0snTkKftmsKdgE=;
	b=pMv4qJwHIj9EEm0b7m6pLdzXruLhLCRh+1JCIiby6QZDs3uqB686BYa9NtQZoBmz
	W9wNCjv/rSDrfowcyKqvFhqBI9aebPsSlqu9D3WTA4QZKZGVAle12gXt4ZHp1ecjPEy
	CPD5gziZdi6FSjaqGWjvWFT9D2mEk781SmjXi3Go=
Received: by mx.zohomail.com with SMTPS id 178281146935498.53515139191438;
	Tue, 30 Jun 2026 02:24:29 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 10/12] nvdimm: virtio_pmem: isolate DMA request buffers
Date: Tue, 30 Jun 2026 17:23:35 +0800
Message-ID: <20260630092338.2094628-11-me@linux.beauty>
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

The virtio-pmem request object stores wait queues, flags, and list
pointers next to buffers mapped for virtqueue DMA. The response buffer is
mapped DMA_FROM_DEVICE, so non-coherent DMA invalidation must not share a
cache line with CPU-owned fields.

Keep the request buffer outside the DMA-from-device group and wrap only
the response buffer with __dma_from_device_group_begin/end.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- New patch.

 drivers/nvdimm/virtio_pmem.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 3af92588bd9d1..8843a8b965874 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_VIRTIO_PMEM_H
 #define _LINUX_VIRTIO_PMEM_H
 
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
 #include <linux/kref.h>
@@ -20,8 +21,6 @@
 
 struct virtio_pmem_request {
 	struct kref kref;
-	struct virtio_pmem_req req;
-	struct virtio_pmem_resp resp;
 
 	/* Wait queue to process deferred work after ack from host */
 	wait_queue_head_t host_acked;
@@ -31,6 +30,11 @@ struct virtio_pmem_request {
 	wait_queue_head_t wq_buf;
 	bool wq_buf_avail;
 	struct list_head list;
+
+	struct virtio_pmem_req req;
+	__dma_from_device_group_begin(resp);
+	struct virtio_pmem_resp resp;
+	__dma_from_device_group_end(resp);
 };
 
 struct virtio_pmem {
-- 
2.52.0
