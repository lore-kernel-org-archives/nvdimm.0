Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050A2168C3
	for <nvdimm@lists.linux.dev>; Wed, 20 Dec 2023 06:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Id7G/cFx"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbcf1b27794so4646806276.2
        for <nvdimm@lists.linux.dev>; Tue, 19 Dec 2023 22:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703052786; x=1703657586; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FytEr1AiciozV1CFLbrh8ZdVPQCwqpJveiMvdE8lpUk=;
        b=Id7G/cFxcesQx0mOkbkDp9S0TYdO6lJiEr/Ip+Dr8hfHMZDpO9fX1xpM6OnJz5l557
         0MCTtDw5a59Uh7x/kQgEIIxexb/kTIzWjdOXCWhfmGdz8PCVdTQ9unvL0R8gQfogHja9
         DhE1vSV9EYbn2svieXZHXLhbtqgkTbTJVvRCkJansy57UpDsP8ipuv/aB0ponLPTBh50
         Qiql8QoqtJPF0a/Jbcfnsg6EfRThiBlDlrAZm5IrVfuCW3zv5Ia4/IyMSUT94pEAckPO
         2HgfUeR+qyZD7syYqUCNCMDO7AjKUdBDJJAFZG+RzloXH2LMlyq9gKC9EdkDSPR8w3jY
         faSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703052786; x=1703657586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FytEr1AiciozV1CFLbrh8ZdVPQCwqpJveiMvdE8lpUk=;
        b=KaOAQmn5ZqhJQGAB66PcBPCV6DKr6ZKSuGpnLQp/ezbSJh/CYcP1xlNmMBohDbw4KB
         T6rqx9nY5kVWPlNoRJfHTAAtaRJsKbV+lM3XsFQXp+uUhud7swvTfH+XIpKBmItVkpxm
         eYt2fqjHdd5QxZtv5Y67JTy2BkA7O9Zr7LUHVixiKjTWcTnBeBT4JossGONxvY42CloF
         yruKh/riws4qPh6RENMDpl5TRc8TTSyNW9jycF71vsznQmMsmlyKdc1YBfl8L3IXq/ba
         Q+nJzUwRhIGniqZk0yeMZR0KCgrPYsChgF96Vtl673HKkNiL0j8Juxidnc8B6OSCpgWI
         8S6w==
X-Gm-Message-State: AOJu0Yx4Yfp28fLkYTtVIF42dhZmU/T5SpEFZqPEhD0vSCvUUXwdtpvk
	sUnsDx3Oc27SUtNvLBOLdq4lh/EmBPQljVs2
X-Google-Smtp-Source: AGHT+IFhU+ACKrdxqy/U0ilwdSG0AHSs/D4KzU5z627yhd9WcP3m3e9s5QcTmMDxLJFBD7GlK/M3LM3b4DBZ6DKr
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2a3:200:2c53:4290:ec42:9360])
 (user=changyuanl job=sendgmr) by 2002:a25:b904:0:b0:db4:5e66:4a05 with SMTP
 id x4-20020a25b904000000b00db45e664a05mr361892ybj.2.1703052785992; Tue, 19
 Dec 2023 22:13:05 -0800 (PST)
Date: Tue, 19 Dec 2023 22:13:00 -0800
In-Reply-To: <CACGkMEuEY5xJyf6H6RgqSuD0PeY9kynYywxzM2+3W6MPaav0Zw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CACGkMEuEY5xJyf6H6RgqSuD0PeY9kynYywxzM2+3W6MPaav0Zw@mail.gmail.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231220061301.228671-1-changyuanl@google.com>
Subject: [PATCH v2] virtio_pmem: support feature SHMEM_REGION
From: Changyuan Lyu <changyuanl@google.com>
To: jasowang@redhat.com
Cc: changyuanl@google.com, dan.j.williams@intel.com, dave.jiang@intel.com, 
	linux-kernel@vger.kernel.org, mst@redhat.com, nvdimm@lists.linux.dev, 
	pankaj.gupta.linux@gmail.com, virtualization@lists.linux.dev, 
	vishal.l.verma@intel.com, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 19, 2023 at 7:57 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, Dec 19, 2023 at 3:19 PM Changyuan Lyu <changyuanl@google.com> wrote:
> >
> > +/* shmid of the shared memory region corresponding to the pmem */
> > +#define VIRTIO_PMEM_SHMCAP_ID 0
>
> NIT: not a native speaker, but any reason for "CAP" here? Would it be
> better to use SHMMEM_REGION_ID?

I was following the name VIRTIO_FS_SHMCAP_ID_CACHE in
include/uapi/linux/virtio_fs.h, where I guess "CAP" was referring to
the shared memory capability when the device is on PCI bus. I agree
SHMMEM_REGION_ID is a better name.

On Tue, Dec 19, 2023 at 3:19 PM Changyuan Lyu <changyuanl@google.com> wrote:
>
> +		if (!have_shm) {
> +			dev_err(&vdev->dev, "failed to get shared memory region %d\n",
> +					VIRTIO_PMEM_SHMCAP_ID);
> +			return -EINVAL;
> +		}

I realized that it needs to jump to tag out_vq to clean up vqs
instead of simply returnning an error.

Thanks for reviewing the patch!

---8<---

As per virtio spec 1.2 section 5.19.5.2, if the feature
VIRTIO_PMEM_F_SHMEM_REGION has been negotiated, the driver MUST query
shared memory ID 0 for the physical address ranges.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>

---
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

