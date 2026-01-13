Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24732EC54D;
	Tue, 13 Jan 2026 03:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768275970; cv=pass; b=gfjU62YlsRguvoWvlmzmA3SaP4sBWK3/ydX5cicezh07xtV7cUd5w+PDnaBuEDCXrVvdWet7g/3dLcmjX3Itoh+1cJDbfPJ4NRe/0l/BrVRHadz6Xc7slfUyWuBfvbTW5IC0bn7R4hyqycBzPveE3TCmo8MHH8ZOxbz1jNdxcEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768275970; c=relaxed/simple;
	bh=yh9WKYXlqUWc5sUsf/ucPYJFwqnKd9qWuYQzeplS0gA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r6+ZXNRSABPnYj+iSCaVr9+zB7Cq7rw8J6/ehLlCXCqTi7R5twg65uY9ZGYOiDlQDR5WkF5pNA9xb6vwju9zxxIMuGE70suVJvG8920Zqttuc0IzyxS/on+JDPmRAafNvu2lii4B8HKWoX4hbx0cY5ER5yx6OsftPWrQb2Zg8V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=hNfzTEga; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="hNfzTEga"
ARC-Seal: i=1; a=rsa-sha256; t=1768275963; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=EZAxQBijCn6Z8Q9Ti677VQ/Pu4qOdsBzKWQ+sS4CwOyFWooPFsy1x4VoPxiWcAPnFp8g7CNHXV+ZA1lQkO/KjWt/n8fjqGnXOdWIl7tT9FWbaaLdA3ZzPRqdXnz9aJhdhtFK+hvJFW5uB9nhcxdGAtCaEa0G3DCTIZQ7eQYUjBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1768275963; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rLeMQF3euqQFHPcQ7Xuf1HGkbhRTdazc0FH9LsglTVo=; 
	b=ZVl0g3qYzlz0TWDLDPVItHJaPeNO+iI7/Q4FommzLYpGIoBMbNw9/AhqtUEhJZAJiLIq0KVpDXkubTtwTIoC14LRRJd9xzPsjS3OO8XX9s022Nmunp4NpGBNYnlAfVuFiik9ehE0UEt9TT4+gxE5vw/9Ga7zOvwczOLO0VFhga0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1768275963;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rLeMQF3euqQFHPcQ7Xuf1HGkbhRTdazc0FH9LsglTVo=;
	b=hNfzTEgaNb7r7XF9rZgSUSdUHZ8pYeTShGa4T7wVDor+vouZtYtyBkWwVssmLjBI
	DxLZRRERi85UmFgOk44r2fwojTgP+2nVTb22VtnhBsaQJJbj/UvTMNz1vBuwSwn7dG9
	+7YSXYqOVrKQ7B9YLS2BfChK5u5bRnOaSAd0a1DY=
Received: by mx.zohomail.com with SMTPS id 1768275959721742.5854641970693;
	Mon, 12 Jan 2026 19:45:59 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Jakub Staron <jstaron@google.com>,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH] nvdimm: virtio_pmem: serialize flush requests
Date: Tue, 13 Jan 2026 11:45:52 +0800
Message-ID: <20260113034552.62805-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Under heavy concurrent flush traffic, virtio-pmem can overflow its request
virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
driver logs "no free slots in the virtqueue". Shortly after that the
device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
"virtio pmem device needs a reset".

Serialize virtio_pmem_flush() with a per-device mutex so only one flush
request is in-flight at a time. This prevents req_vq descriptor overflow
under high concurrency.

Reproducer (guest with virtio-pmem):
  - mkfs.ext4 -F /dev/pmem0
  - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
  - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
        direct=1 fsync=1 runtime=30s time_based=1
  - dmesg: "no free slots in the virtqueue"
           "virtio pmem device needs a reset"

Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/nvdimm/nd_virtio.c   | 15 +++++++++++----
 drivers/nvdimm/virtio_pmem.c |  1 +
 drivers/nvdimm/virtio_pmem.h |  4 ++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa22..827a17fe7c71 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,19 +44,24 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	might_sleep();
+	mutex_lock(&vpmem->flush_lock);
+
 	/*
 	 * Don't bother to submit the request to the device if the device is
 	 * not activated.
 	 */
 	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
 		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
-		return -EIO;
+		err = -EIO;
+		goto out_unlock;
 	}
 
-	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
-	if (!req_data)
-		return -ENOMEM;
+	if (!req_data) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
 
 	req_data->done = false;
 	init_waitqueue_head(&req_data->host_acked);
@@ -103,6 +108,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	}
 
 	kfree(req_data);
+out_unlock:
+	mutex_unlock(&vpmem->flush_lock);
 	return err;
 };
 
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 2396d19ce549..77b196661905 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -64,6 +64,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		goto out_err;
 	}
 
+	mutex_init(&vpmem->flush_lock);
 	vpmem->vdev = vdev;
 	vdev->priv = vpmem;
 	err = init_vq(vpmem);
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 0dddefe594c4..f72cf17f9518 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
 #include <linux/libnvdimm.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 struct virtio_pmem_request {
@@ -35,6 +36,9 @@ struct virtio_pmem {
 	/* Virtio pmem request queue */
 	struct virtqueue *req_vq;
 
+	/* Serialize flush requests to the device. */
+	struct mutex flush_lock;
+
 	/* nvdimm bus registers virtio pmem device */
 	struct nvdimm_bus *nvdimm_bus;
 	struct nvdimm_bus_descriptor nd_desc;
-- 
2.52.0

