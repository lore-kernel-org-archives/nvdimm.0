Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A85A3655F5;
	Tue, 18 Aug 2026 21:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787087763; cv=none; b=L8gsCui3/d80GZRvSPZDGto6NEB10O0bIfir30IRpKZmAvhTAyq784RczY/ZwWr954iI+fNXUxcP7cRrWBTcI1jNQBMQMkriwsyJMH2qPbGXzcbKICVrKqCH43xqtIewzv1VKiJf3oeg+M0MgT4r7OK/Q6bH/yEK8ap30gimVzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787087763; c=relaxed/simple;
	bh=4MY1E6UsTaTD3JaTsTGhg6GLs9aCwoiCB5KiqqWpYfI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eA28mmMpNK45hAuCIkzzZuerR2oBMkgxLrOdS0TAIfRBMgu9kMny5euWKXPUbuINZhuXL51KgPY0MmsRAV0nsrJ51dyfgtfkdTYKAD03Xes+EtayV9hm0M0KCiKndmF2E1IIn6sPZ60GFsJcUtLLdtyVz9RXy+pOclp80xIdbyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=m7hrWoDP; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="m7hrWoDP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787087760; x=1818623760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FApHzJFmH3uYxjRp8VczKcT+B0VLtqz+JIgk2HKXA5E=;
  b=m7hrWoDPW0Nna56wF5Mjs084Q/ul66AFB4LkHc7fqWEznDztDuGt7gf0
   UqvrHZJ6+TCBTH2eJFTj0Rx2BXA4V7viLRTI4SLiafDqZ6wbVx0YvDXwu
   LXKByVnHtB8MRQFcbL8q9c9jAFsNs2QLfo/9lvCksFPnfCEvR6DQDxp+p
   j8vBFKChOZrBXBuviEeBUT8KIn4mUjfVYrgTEtLKM/rTpSBYFCM5wkY7V
   7eM78V2HTEsCbdMszXrXISvxAPnOnV3Ns7qKp3O2B6P2TgaQukNg4o/83
   FHgK52H1QMA6elFRjoSETSg5erocJSyrielqeMUY2YHHOcOzqGsy6mGn/
   g==;
X-CSE-ConnectionGUID: KkP1ycQWQP+FJrkaQgIJjg==
X-CSE-MsgGUID: PyF4IRphS52SmCZNpbmsFw==
X-IronPort-AV: E=Sophos;i="6.25,230,1779148800"; 
   d="scan'208";a="26291456"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 21:15:57 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:10560]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.2.175:2525] with esmtp (Farcaster)
 id 3922ea29-a917-4db8-bf9e-a9be5615191c; Tue, 18 Aug 2026 21:15:57 +0000 (UTC)
X-Farcaster-Flow-ID: 3922ea29-a917-4db8-bf9e-a9be5615191c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 18 Aug 2026 21:15:56 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 18 Aug 2026 21:15:54 +0000
From: Alexander Graf <graf@amazon.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>
CC: <nh-open-source@amazon.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, <linux-block@vger.kernel.org>, David Airlie
	<airlied@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Dmitry Osipenko
	<dmitry.osipenko@collabora.com>, <dri-devel@lists.freedesktop.org>, "Pankaj
 Gupta" <pankaj.gupta.linux@gmail.com>, <nvdimm@lists.linux.dev>, "Stefan
 Hajnoczi" <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 11/12] virtio_pci: support VIRTIO_F_DMB
Date: Tue, 18 Aug 2026 21:14:24 +0000
Message-ID: <20260818211425.91009-12-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260818211425.91009-1-graf@amazon.com>
References: <20260818211425.91009-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Let a modern virtio-pci device place its virtqueues and the buffers they
reference in a Device Memory Buffer of its own: accept VIRTIO_F_DMB from
vp_transport_features(), and implement the get_dmb_shm_id config op on
top of vp_modern_get_dmb_shm_id(). get_dmb_shm_id reports the shared
memory id of the region that holds the buffer.

Take the offer only for a dmb_mem_type of VIRTIO_DMB_MEM_TYPE_COHERENT,
the memory type that says a write by either side becomes visible to the
other with no cache maintenance by the driver. The driver uses plain
loads and stores on the region, so no other type will do. The field is
valid from the moment the device offers the feature, so a type the driver
does not support leaves the device driven as an ordinary one. The shmid
is not readable that early, so a region we fail to locate after the
accept fails virtio_features_ok() and probe sets the FAILED status bit.

Refuse a device whose common configuration is too short to hold
dmb_mem_type, which would put that read outside what vp_modern_probe()
mapped. The accept path measures the structure itself, because
vp_check_common_size() runs on the features the driver has already
accepted and so cannot cover a read that precedes it.

Two more things gate the accept. CONFIG_VIRTIO_DMB, so that a device
offering the feature to a kernel built without it is driven as an ordinary
device. And VIRTIO_F_VERSION_1, because virtio_features_ok() returns early
without it, which would leave the feature negotiated and the region never
built; this transport refuses such a device anyway.

Link: https://lore.kernel.org/virtio-comment/20260818060255.6853-1-graf@amazon.com/
Assisted-by: Kiro:claude-opus-5 checkpatch sparse
Signed-off-by: Alexander Graf <graf@amazon.com>
---

  - Explain in a comment how a transport feature survives negotiation
  - Say ACCESS_PLATFORM is implied rather than dismissing it

---
 drivers/virtio/virtio_pci_modern.c | 58 ++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 565d37b630b3..c893e31e5159 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -364,6 +364,29 @@ static void vp_modern_avq_cleanup(struct virtio_device *vdev)
 	}
 }
 
+/*
+ * A device reports the memory type of its Device Memory Buffer region in
+ * dmb_mem_type, and the field is valid as soon as the device offers
+ * VIRTIO_F_DMB.  VIRTIO_DMB_MEM_TYPE_COHERENT says that a write by either side
+ * becomes visible to the other with no cache maintenance by the driver, which
+ * is what plain loads and stores on the region need.  A common configuration
+ * structure too short to hold the field reports no type at all, and reading it
+ * there would fall outside what vp_modern_probe() mapped.  This is the only
+ * place that measures the structure against the field, because the read
+ * happens before vp_check_common_size() runs.
+ */
+static bool vp_dmb_mem_type_supported(struct virtio_pci_device *vp_dev)
+{
+	size_t need = offsetofend(struct virtio_pci_modern_common_cfg,
+				  dmb_mem_type);
+
+	if (vp_dev->mdev.common_len < need)
+		return false;
+
+	return vp_modern_get_dmb_mem_type(&vp_dev->mdev) ==
+	       VIRTIO_DMB_MEM_TYPE_COHERENT;
+}
+
 static void vp_transport_features(struct virtio_device *vdev, u64 features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -378,6 +401,30 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
 
 	if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
 		__virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
+
+	/*
+	 * vring_transport_features() clears every bit in the transport range
+	 * that the ring itself does not consume, and vp_finalize_features()
+	 * hands the features the device offered to this function afterwards.
+	 * A transport feature therefore survives negotiation only if the
+	 * transport sets it again here, the way VIRTIO_F_SR_IOV,
+	 * VIRTIO_F_RING_RESET and VIRTIO_F_ADMIN_VQ do above, so this is where
+	 * the driver accepts a Device Memory Buffer and declining refuses it.
+	 *
+	 * VIRTIO_F_VERSION_1 is required because the core locates and releases
+	 * the region from virtio_features_ok(), which returns before it gets
+	 * that far for a device without VERSION_1, so accepting the feature
+	 * without it would leave the feature negotiated and the region never
+	 * built.  VIRTIO_F_ACCESS_PLATFORM is not required alongside it,
+	 * because virtio_has_dma_quirk() already reads this feature as
+	 * carrying what that one asserts.  Whether the device asks for the
+	 * stronger barriers is its own business and does not bear on this one.
+	 */
+	if (IS_ENABLED(CONFIG_VIRTIO_DMB) &&
+	    (features & BIT_ULL(VIRTIO_F_DMB)) &&
+	    (features & BIT_ULL(VIRTIO_F_VERSION_1)) &&
+	    vp_dmb_mem_type_supported(vp_dev))
+		__virtio_set_bit(vdev, VIRTIO_F_DMB);
 }
 
 static int __vp_check_common_size_one_feature(struct virtio_device *vdev, u32 fbit,
@@ -878,6 +925,15 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
 	return true;
 }
 
+static int vp_get_dmb_shm_id(struct virtio_device *vdev, u16 *id)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	*id = vp_modern_get_dmb_shm_id(&vp_dev->mdev);
+
+	return 0;
+}
+
 /*
  * virtio_pci_admin_has_dev_parts - Checks whether the device parts
  * functionality is supported
@@ -1241,6 +1297,7 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.get_dmb_shm_id = vp_get_dmb_shm_id,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
 };
@@ -1261,6 +1318,7 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_vq_affinity = vp_set_vq_affinity,
 	.get_vq_affinity = vp_get_vq_affinity,
 	.get_shm_region  = vp_get_shm_region,
+	.get_dmb_shm_id = vp_get_dmb_shm_id,
 	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
 	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
 };
