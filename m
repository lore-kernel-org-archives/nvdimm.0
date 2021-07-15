Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7655D168
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 22:35:05 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1096)
	id 1D9ED20B6C14; Thu, 15 Jul 2021 15:35:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1D9ED20B6C14
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1626388505;
	bh=0Y9wwxU/DVdA5BAO3tI9BpMGIlkLOOdAAoja4Q5yrk0=;
	h=Date:From:To:Cc:Subject:From;
	b=WjfqvAakEex0agxi0BhGpQBN9bjE+A7hui7gQWH8jTpVj1IVgJTFRKrwrQfVH7rB9
	 8GxZvo16DXyKcaQgqqafdiQfacGrHzq4fWKJ5rkyzJlO2UMsFuYIqqUUJbCWvWt8u6
	 walR5vll1M9UfH5uhTpEaiqJ1hqhPe7upgSu/SwY=
Date: Thu, 15 Jul 2021 15:35:05 -0700
From: Taylor Stark <tstark@linux.microsoft.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev, apais@microsoft.com, tyhicks@microsoft.com,
	jamorris@microsoft.com, benhill@microsoft.com,
	sunilmut@microsoft.com, grahamwo@microsoft.com,
	tstark@microsoft.com
Subject: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)

Update virtio-pmem to allow for the pmem region to be specified in either
guest absolute terms or as a PCI BAR-relative address. This is required
to support virtio-pmem in Hyper-V, since Hyper-V only allows PCI devices
to operate on PCI memory ranges defined via BARs.

Virtio-pmem will check for a shared memory window and use that if found,
else it will fallback to using the guest absolute addresses in
virtio_pmem_config. This was chosen over defining a new feature bit,
since it's similar to how virtio-fs is configured.

Signed-off-by: Taylor Stark <tstark@microsoft.com>
---
 drivers/nvdimm/virtio_pmem.c | 21 +++++++++++++++++----
 drivers/nvdimm/virtio_pmem.h |  3 +++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 726c7354d465..43c1d835a449 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -37,6 +37,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	struct virtio_pmem *vpmem;
 	struct resource res;
 	int err = 0;
+	bool have_shm_region;
+	struct virtio_shm_region pmem_region;
 
 	if (!vdev->config->get) {
 		dev_err(&vdev->dev, "%s failure: config access disabled\n",
@@ -58,10 +60,21 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		goto out_err;
 	}
 
-	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
-			start, &vpmem->start);
-	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
-			size, &vpmem->size);
+	/* Retrieve the pmem device's address and size. It may have been supplied
+	 * as a PCI BAR-relative shared memory region, or as a guest absolute address.
+	 */
+	have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
+						VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
+
+	if (have_shm_region) {
+		vpmem->start = pmem_region.addr;
+		vpmem->size = pmem_region.len;
+	} else {
+		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
+				start, &vpmem->start);
+		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
+				size, &vpmem->size);
+	}
 
 	res.start = vpmem->start;
 	res.end   = vpmem->start + vpmem->size - 1;
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 0dddefe594c4..62bb564e81cb 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -50,6 +50,9 @@ struct virtio_pmem {
 	__u64 size;
 };
 
+/* For the id field in virtio_pci_shm_cap */
+#define VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION 0
+
 void virtio_pmem_host_ack(struct virtqueue *vq);
 int async_pmem_flush(struct nd_region *nd_region, struct bio *bio);
 #endif
-- 
2.32.0

