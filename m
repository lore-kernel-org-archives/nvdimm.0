Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E65C130
	for <nvdimm@lists.linux.dev>; Tue, 19 Dec 2023 07:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zbJ+OK17"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbd5ba9cbc7so73629276.3
        for <nvdimm@lists.linux.dev>; Mon, 18 Dec 2023 23:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702970389; x=1703575189; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gZWYP/oOlOggqgKUebMmGuOo7PQ5M/AycpxW1yV0m6w=;
        b=zbJ+OK17/OD43EpXOj6lZHBGFNYeM0L6MBY4Inb1gRqzJoeDjxJU4LRluGjx8Di5iX
         wYPA7V7nGgmCcnQAMs12jUn6tVsQG3i9rpnBBVOuvCHYAU7EAecP33aoKznAQCHMequs
         Z6ssBCGCwlWB5YEUgz3gZIbNNOrfR2e4JVb/rXlejBqeYI+6mG8ArARNW7H71Ht4uZdx
         aPXSbkuV7bxsDMdg9OzYW3cZ+Pk2Xzz2JG074fsZdhG+BGAFWcVDOkTPs80d7gTRm8uB
         z6XMj6buWLMBVEDoemTbcSrkTArq1N1kJEqqgPZ2rW3wDkFu3mp5HY76TsbRw6rgq8hG
         Mzsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702970389; x=1703575189;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gZWYP/oOlOggqgKUebMmGuOo7PQ5M/AycpxW1yV0m6w=;
        b=RDO74GMB2J1+9OeSUEFsyIJ88uDSOHSw6ITORsdzbVKC/P/EVya1iehatnl+Wj1IWf
         gSax4cQjRf4Z/V0UxfL/rjAW5OlsboxAi8YFT2rgHtw4tqCq1l8j6pLaLGNcwMEfrUN5
         f+NHbqrsK8faZicxh3MangKzIEFfvqPCuYhJ4v2/kYw5Xqe/MZyksFy3IYluTNnXRAxj
         t50zpDtM/25S7KpSj2BS/Fu/CK0oNGgBqDxDczr2+w/hw/ASLar0VarOu9K78i6bZ1vr
         r57zev4D51REkMMMZNv3l9b3O+KvONdxjkIkXdrhbpAr5HVnklnjLhHy41IiWQ9qheag
         KbRA==
X-Gm-Message-State: AOJu0Yz04/Xbc0PJ+cKcpNX2lOL9OiVzJe/BczwhPde4phuJjBLBM/g5
	nkbTu9Uc/BsLBGuvaMfUAww6x7YPGDPtQveS
X-Google-Smtp-Source: AGHT+IE+rN4NVhqEMOpU1c0Y1JbYbMaraxu/g+XW3gohe7Z0gme65cSYEjDzpnlNRx8dnz8oXjI74er4NvKN5KMi
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2a3:200:b586:7ce5:ab58:992c])
 (user=changyuanl job=sendgmr) by 2002:a25:b904:0:b0:db4:5e66:4a05 with SMTP
 id x4-20020a25b904000000b00db45e664a05mr324670ybj.2.1702970388799; Mon, 18
 Dec 2023 23:19:48 -0800 (PST)
Date: Mon, 18 Dec 2023 23:18:49 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231219071849.3912896-1-changyuanl@google.com>
Subject: [PATCH] virtio_pmem: support feature SHMEM_REGION
From: Changyuan Lyu <changyuanl@google.com>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Changyuan Lyu <changyuanl@google.com>
Content-Type: text/plain; charset="UTF-8"

As per virtio spec 1.2 section 5.19.5.2, if the feature
VIRTIO_PMEM_F_SHMEM_REGION has been negotiated, the driver MUST query
shared memory ID 0 for the physical address ranges.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 drivers/nvdimm/virtio_pmem.c     | 29 +++++++++++++++++++++++++----
 include/uapi/linux/virtio_pmem.h |  8 ++++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index a92eb172f0e7..5b28d543728b 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -35,6 +35,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	struct nd_region *nd_region;
 	struct virtio_pmem *vpmem;
 	struct resource res;
+	struct virtio_shm_region shm_reg;
+	bool have_shm;
 	int err = 0;
 
 	if (!vdev->config->get) {
@@ -57,10 +59,23 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		goto out_err;
 	}
 
-	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
-			start, &vpmem->start);
-	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
-			size, &vpmem->size);
+	if (virtio_has_feature(vdev, VIRTIO_PMEM_F_SHMEM_REGION)) {
+		have_shm = virtio_get_shm_region(vdev, &shm_reg,
+				(u8)VIRTIO_PMEM_SHMCAP_ID);
+		if (!have_shm) {
+			dev_err(&vdev->dev, "failed to get shared memory region %d\n",
+					VIRTIO_PMEM_SHMCAP_ID);
+			return -EINVAL;
+		}
+		vpmem->start = shm_reg.addr;
+		vpmem->size = shm_reg.len;
+	} else {
+		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
+				start, &vpmem->start);
+		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
+				size, &vpmem->size);
+	}
+
 
 	res.start = vpmem->start;
 	res.end   = vpmem->start + vpmem->size - 1;
@@ -122,7 +137,13 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 }
 
+static unsigned int features[] = {
+	VIRTIO_PMEM_F_SHMEM_REGION,
+};
+
 static struct virtio_driver virtio_pmem_driver = {
+	.feature_table		= features,
+	.feature_table_size	= ARRAY_SIZE(features),
 	.driver.name		= KBUILD_MODNAME,
 	.driver.owner		= THIS_MODULE,
 	.id_table		= id_table,
diff --git a/include/uapi/linux/virtio_pmem.h b/include/uapi/linux/virtio_pmem.h
index d676b3620383..025174f6eacf 100644
--- a/include/uapi/linux/virtio_pmem.h
+++ b/include/uapi/linux/virtio_pmem.h
@@ -14,6 +14,14 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
+/* Feature bits */
+#define VIRTIO_PMEM_F_SHMEM_REGION 0	/* guest physical address range will be
+					 * indicated as shared memory region 0
+					 */
+
+/* shmid of the shared memory region corresponding to the pmem */
+#define VIRTIO_PMEM_SHMCAP_ID 0
+
 struct virtio_pmem_config {
 	__le64 start;
 	__le64 size;
-- 
2.43.0.472.g3155946c3a-goog

