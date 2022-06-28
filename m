Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574D67A
	for <nvdimm@lists.linux.dev>; Tue, 28 Jun 2022 08:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656405294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tG2I7aLFwQB0Roi6WlSImPu69yOCfGrYWC9fgF3Fn1s=;
	b=UyG2tfYQOPfQ1ct00KYbol5DEg/h4WwH4dYI/+VfkWlJ1HIOC/FfmmmLnrGMrlGLkYBMgo
	aWYeyuB/eqoHElN3h/EmNsOeNb8v5IsnTSB/dK9PLSTiAEJGd41F8U9IooHuRxwMfnySo0
	783t2cYKg5sZcSQ4fjDp9VG/HOdGwnE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-yPEWJTdGPLaq9gtFQEUxTw-1; Tue, 28 Jun 2022 04:34:43 -0400
X-MC-Unique: yPEWJTdGPLaq9gtFQEUxTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A23488FE6C5;
	Tue, 28 Jun 2022 08:34:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-87.pek2.redhat.com [10.72.13.87])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7B7FC15D40;
	Tue, 28 Jun 2022 08:34:38 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mst@redhat.com
Cc: Jason Wang <jasowang@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH V3 2/2] virtio_pmem: set device ready in probe()
Date: Tue, 28 Jun 2022 16:34:30 +0800
Message-Id: <20220628083430.61856-2-jasowang@redhat.com>
In-Reply-To: <20220628083430.61856-1-jasowang@redhat.com>
References: <20220628083430.61856-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8

The NVDIMM region could be available before the virtio_device_ready()
that is called by virtio_dev_probe(). This means the driver tries to
use device before DRIVER_OK which violates the spec, fixing this by
set device ready before the nvdimm_pmem_region_create().

Note that this means the virtio_pmem_host_ack() could be triggered
before the creation of the nd region, this is safe since the pmem_lock
has been initialized and whether or not any available buffer is added
before is validated by virtio_pmem_host_ack().

Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V2:
- Tweak the change log
Changes since v1:
- Remove some comments per Dan
---
 drivers/nvdimm/virtio_pmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 48f8327d0431..20da455d2ef6 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -84,6 +84,12 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	ndr_desc.provider_data = vdev;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
 	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
+	/*
+	 * The NVDIMM region could be available before the
+	 * virtio_device_ready() that is called by
+	 * virtio_dev_probe(), so we set device ready here.
+	 */
+	virtio_device_ready(vdev);
 	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
 	if (!nd_region) {
 		dev_err(&vdev->dev, "failed to create nvdimm region\n");
@@ -92,6 +98,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	}
 	return 0;
 out_nd:
+	virtio_reset_device(vdev);
 	nvdimm_bus_unregister(vpmem->nvdimm_bus);
 out_vq:
 	vdev->config->del_vqs(vdev);
-- 
2.25.1

