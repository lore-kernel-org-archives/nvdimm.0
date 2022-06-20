Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECB07E6
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 08:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655712931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I1lYpNTrUnt7Btfovr3DlYiMYkzht/GR4hSoglU/hEY=;
	b=gj6B7vx5OGse9RdhtSxSlhYevLjnTTD4/7vdPt2VGdoIdkhZrKyasOZ/cOVEWeoakaW/fi
	A4CbMNdR5MlP7dEvxJ1+oqh6p8MFvPWZMpIfOfK8FQafyxh3gnePYHrGXUWyjkU6MVgsvB
	7EbtXkwNiBLH0ym9T3WDwdCqSDfIw6g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-oZE2zdRrMqeGa1hAqdf7RA-1; Mon, 20 Jun 2022 04:15:30 -0400
X-MC-Unique: oZE2zdRrMqeGa1hAqdf7RA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0286180B70E;
	Mon, 20 Jun 2022 08:15:30 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-200.pek2.redhat.com [10.72.13.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8216F40BB4F;
	Mon, 20 Jun 2022 08:15:26 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	mst@redhat.com,
	jasowang@redhat.com
Subject: [PATCH 2/2] virtio_pmem: set device ready in probe()
Date: Mon, 20 Jun 2022 16:15:19 +0800
Message-Id: <20220620081519.1494-2-jasowang@redhat.com>
In-Reply-To: <20220620081519.1494-1-jasowang@redhat.com>
References: <20220620081519.1494-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit

The NVDIMM region could be available before the virtio_device_ready()
that is called by virtio_dev_probe(). This means the driver tries to
use device before DRIVER_OK which violates the spec, fixing this by
set device ready before the nvdimm_pmem_region_create().

Note that this means the virtio_pmem_host_ack() could be triggered
before the creation of the nd region, this is safe since the
virtio_pmem_host_ack() since pmem_lock has been initialized and we
check if we've added any buffer before trying to proceed.

Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 48f8327d0431..173f2f5adaea 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	ndr_desc.provider_data = vdev;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
 	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
+	/*
+	 * The NVDIMM region could be available before the
+	 * virtio_device_ready() that is called by
+	 * virtio_dev_probe(), so we set device ready here.
+	 *
+	 * The callback - virtio_pmem_host_ack() is safe to be called
+	 * before the nvdimm_pmem_region_create() since the pmem_lock
+	 * has been initialized and legality of a used buffer is
+	 * validated before moving forward.
+	 */
+	virtio_device_ready(vdev);
 	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
 	if (!nd_region) {
 		dev_err(&vdev->dev, "failed to create nvdimm region\n");
@@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	}
 	return 0;
 out_nd:
+	virtio_reset_device(vdev);
 	nvdimm_bus_unregister(vpmem->nvdimm_bus);
 out_vq:
 	vdev->config->del_vqs(vdev);
-- 
2.25.1

