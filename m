Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655D618E07
	for <nvdimm@lists.linux.dev>; Wed, 20 Dec 2023 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W9gkafwf"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbce9c6cd26so5819359276.0
        for <nvdimm@lists.linux.dev>; Tue, 19 Dec 2023 23:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703057611; x=1703662411; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=twveIrdTcd/mulXsZ5S2piYz3X+8ZAw3Sbz5Wtujg/U=;
        b=W9gkafwfoADvKErJy6UzeE0CllJzIaHcUzT4HsanDwi7L4q3ZA98EKls4bOx+YNP7m
         hNQfIPhlr9iU3BTELXYGCp9/ZmYP5WZNeXLm9a1AvSsKu5xOO/nQ9p4Qpik0LoWZilZB
         45j8sJhKgS0UquCa5949bTm4R5jvHzFzUCt30TdSxeo6cxeON7fqF5uZrv0dWItEPAZE
         VZl+4AopsjK/KICqnPx3WHI+s4SVKYxZAJcPKOtGQxEl5GTtNZqL961TrsMXSiQbxhuk
         L6ws1ZL9PeVxChU5eSB9fEcbAdgjLv1EPbBUbAQsOvfGnXJxoBk1Nl7IBwNeN+uuOnmG
         EoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703057611; x=1703662411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twveIrdTcd/mulXsZ5S2piYz3X+8ZAw3Sbz5Wtujg/U=;
        b=bO2wCnNXOiCKXvHZ5eJObAP8i1gjI5sHtIywUDjp26jRFJVxTakaSTkWsURlmfDMmv
         xP4hOYWnJVwU1qSM3huUQtwAFMZNlFXuf5c1DPKYCngCipFXtZrN9n18fcZ5BnIojJSI
         P9iVkHCcAgPYZZcFUVAlXKuHHhMjVVqUzBb+Qs+Wlj5BGa951ZDhicCW5lNzcFsNDUAC
         eqsgi6KpnWSpbdx7ZRbLvegn+A2xoXZgJkn3MgWPIDyC8pNjGehfgffduphob8oi+Ri8
         yRuobEzi8OMQT5L76c+Fo5RfVuxnu00G+mHkh5n94mRdNhlebVmpJvNxuEKKGGOBJ+2A
         bzew==
X-Gm-Message-State: AOJu0YxD09YTm3O7gh+YsmT2NXaqxbVnEbfDv1f3+UM9D93J5OaJkQ4L
	EHoLf7QBxV3ln+VeHTWWTw0VqjhcWz+XzW99
X-Google-Smtp-Source: AGHT+IFgIl8umfUHjjsA9gTZqJL4tpauFYgrM50BhRXTIf57FHoLEgTJR8p0S0qgUwaz+Y8q6eDmm27wpLrnBJhu
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2a3:200:2c53:4290:ec42:9360])
 (user=changyuanl job=sendgmr) by 2002:a25:8041:0:b0:dbc:fb31:e5f with SMTP id
 a1-20020a258041000000b00dbcfb310e5fmr2508826ybn.10.1703057611420; Tue, 19 Dec
 2023 23:33:31 -0800 (PST)
Date: Tue, 19 Dec 2023 23:32:27 -0800
In-Reply-To: <20231220020100-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231220020100-mutt-send-email-mst@kernel.org>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231220073227.252605-1-changyuanl@google.com>
Subject: [PATCH v3] virtio_pmem: support feature SHMEM_REGION
From: Changyuan Lyu <changyuanl@google.com>
To: mst@redhat.com
Cc: changyuanl@google.com, dan.j.williams@intel.com, dave.jiang@intel.com, 
	jasowang@redhat.com, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	pankaj.gupta.linux@gmail.com, virtualization@lists.linux.dev, 
	vishal.l.verma@intel.com, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 19, 2023 at 11:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> This is not a great description. Please describe what the patch does.

Thanks for the feedback! Please see the v3 patch below.

---8<---

This patch adds the support for feature VIRTIO_PMEM_F_SHMEM_REGION
(virtio spec v1.2 section 5.19.5.2 [1]). Feature bit
VIRTIO_PMEM_F_SHMEM_REGION is added to the driver feature
table.

If the driver feature bit VIRTIO_PMEM_F_SHMEM_REGION is found,
during probe, virtio pmem ignores the `start` and `size` fields in
device config and looks for a shared memory region of id 0. The
physical address range of the pmem is then determined by the physical
address range of shared memory region 0.

[1] https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.html#x1-6480002

Signed-off-by: Changyuan Lyu <changyuanl@google.com>

---
v3:
  * updated the patch description.
V2:
  * renamed VIRTIO_PMEM_SHMCAP_ID to VIRTIO_PMEM_SHMEM_REGION_ID
  * fixed the error handling when region 0 does not exist
---
 drivers/nvdimm/virtio_pmem.c     | 30 ++++++++++++++++++++++++++----
 include/uapi/linux/virtio_pmem.h |  8 ++++++++
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index a92eb172f0e7..8e447c7558cb 100644
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
@@ -57,10 +59,24 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		goto out_err;
 	}
 
-	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
-			start, &vpmem->start);
-	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
-			size, &vpmem->size);
+	if (virtio_has_feature(vdev, VIRTIO_PMEM_F_SHMEM_REGION)) {
+		have_shm = virtio_get_shm_region(vdev, &shm_reg,
+				(u8)VIRTIO_PMEM_SHMEM_REGION_ID);
+		if (!have_shm) {
+			dev_err(&vdev->dev, "failed to get shared memory region %d\n",
+					VIRTIO_PMEM_SHMEM_REGION_ID);
+			err = -ENXIO;
+			goto out_vq;
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
@@ -122,7 +138,13 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
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
index d676b3620383..c5e49b6e58b1 100644
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
+#define VIRTIO_PMEM_SHMEM_REGION_ID 0
+
 struct virtio_pmem_config {
 	__le64 start;
 	__le64 size;
-- 
2.43.0.472.g3155946c3a-goog

