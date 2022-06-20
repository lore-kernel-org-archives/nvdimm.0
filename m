Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5D7E6
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 08:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655712929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XwcQu6ci4N2X/+isQl+PgSoUtz2wwX9pYdKQx2UCo1E=;
	b=Bi+DuEGfwuBF/RcM9aQdMQxC9IaMbjWaNM6wCjCH1gRuTkLDaW8LqUr5OVmWFuGTgZguyb
	XWediY76e7kulbFppwl0t+BZFr92/fJOdKfHCPDxxqAwR+V/VkvczH8XAHpL+s4RqeUGZ4
	mkzTlYS16meb+QvzMm54j1RM0VbPECM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-StQ-mj_hOoKGqxt_nmJ4xw-1; Mon, 20 Jun 2022 04:15:26 -0400
X-MC-Unique: StQ-mj_hOoKGqxt_nmJ4xw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2F558316FB;
	Mon, 20 Jun 2022 08:15:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-200.pek2.redhat.com [10.72.13.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6448A40314B;
	Mon, 20 Jun 2022 08:15:22 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	mst@redhat.com,
	jasowang@redhat.com
Subject: [PATCH 1/2] virtio_pmem: initialize provider_data through nd_region_desc
Date: Mon, 20 Jun 2022 16:15:18 +0800
Message-Id: <20220620081519.1494-1-jasowang@redhat.com>
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

We used to initialize the provider_data manually after
nvdimm_pemm_region_create(). This seems to be racy if the flush is
issued before the initialization of provider_data. Fixing this by
initialize the provider_data through nd_region_desc to make sure the
provider_data is ready after the pmem is created.

Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/nvdimm/virtio_pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 995b6cdc67ed..48f8327d0431 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -81,6 +81,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	ndr_desc.res = &res;
 	ndr_desc.numa_node = nid;
 	ndr_desc.flush = async_pmem_flush;
+	ndr_desc.provider_data = vdev;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
 	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
 	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
@@ -89,7 +90,6 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		err = -ENXIO;
 		goto out_nd;
 	}
-	nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
 	return 0;
 out_nd:
 	nvdimm_bus_unregister(vpmem->nvdimm_bus);
-- 
2.25.1

