Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8218F3655FD;
	Sun, 21 Jun 2026 13:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047039; cv=pass; b=ejxOu7gtxXn7YMTovNb8XYyetksFW5uztY2naU8g8yB7gLyc4BNKUyD2sA4oC88Dx96ABam2P96/bSB+fMygL3e5c1QjRHuizR9Z2a6dVaZxRRVbpaFL6TxjmIxgJ/jleiYBFJAHO6Y7NQBpKMd9sP39vwCfuT6MQXwPik5Hq3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047039; c=relaxed/simple;
	bh=AuZG6eLVxtRjnPbYcuX0f0Nm13o7MKcCVWJRxui5OnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmEMLk5tt0t8sLILGOkWZ4zm3hgetQzltju6XuXSqG+Sd/lG6ifGKK/8Vjew7PNqK2vdmteSOsdwba36ZPwxOCRX2cFHGp9CBxMVprvmY1Iru2/EZOPGCyMzR95vnmZHXl6JzcgI1jq8FRZNCR+yN5CaMpN8tPuvcI04pehx7eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ek8+MBuj; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ek8+MBuj"
ARC-Seal: i=1; a=rsa-sha256; t=1782047020; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bfaJ9l7nNjq+fyqJ7vWYfioo80HaaNE6oCdLgYWe5PQ6HN1R338bVXRgVj0ObM9SAw3njsy6HaktJOOPvmQ36EchKPvysT6aOa8RIVvRc+Q2oeKACIuL6ht0PQGiIcnvCiCEX3uKUw/FwA8EkGom0Vd/nue+M2I0HmR8BBnFo7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047020; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=MEsva7hJtbMtZ8GDT7P31U3EHKfjcwNJzPN0mOdKvuQ=; 
	b=Q0v1Z0EPoeOBBRVAkFPKlnWbKTf6wtvTryHRwnNhD2QWE8aHU2xIvPJi0xndoNKpP6c3GYm3eJZry7Oi+rkOu5mhHJI/hZI8aOsHQV6U8rllq1DOQDuY3GpvzKv/Yk8GLVw/dV72rpG/hxJRvHSEEPuSrfHPTDZgKwuyW/iUm+w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047020;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=MEsva7hJtbMtZ8GDT7P31U3EHKfjcwNJzPN0mOdKvuQ=;
	b=ek8+MBujHE+ItXMDGilx144xNRG0Uin7RXIFskcKk80FN4AzQRFvZFH+KZrtRgOG
	HzotoXnFF2nhh9u1R8730EKjekj9Tps1C7P2vX+5+4MsFbQr5TXgyKJvICdE9fVj4OQ
	49wo26f6lVC9VjVaI5eWukBl2eiYE4wHqXt0f/iI=
Received: by mx.zohomail.com with SMTPS id 1782047017371275.4613699500153;
	Sun, 21 Jun 2026 06:03:37 -0700 (PDT)
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
Subject: [PATCH v6 10/12] nvdimm: virtio_pmem: isolate DMA request buffers
Date: Sun, 21 Jun 2026 21:02:41 +0800
Message-ID: <20260621130246.2973254-11-me@linux.beauty>
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
index 1017e498c9b4c..23bff40249c1b 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_VIRTIO_PMEM_H
 #define _LINUX_VIRTIO_PMEM_H
 
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
 #include <linux/kref.h>
@@ -19,8 +20,6 @@
 
 struct virtio_pmem_request {
 	struct kref kref;
-	struct virtio_pmem_req req;
-	struct virtio_pmem_resp resp;
 
 	/* Wait queue to process deferred work after ack from host */
 	wait_queue_head_t host_acked;
@@ -30,6 +29,11 @@ struct virtio_pmem_request {
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
