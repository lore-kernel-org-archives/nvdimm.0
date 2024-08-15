Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB6715CB
	for <nvdimm@lists.linux.dev>; Thu, 15 Aug 2024 00:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723682785; cv=none; b=dNW4mhzyoGutCGlN5DHWTxklVAG/JQg63eW35JeMofcwzyUXrkLG7YCX60x/PM7cSecJGzU8mBKsbxR5yy3pf0Xm4ImqhKMC7Sgcl2lFU9OWTW1OGbWZU1lQc05Bd3sPOj3NeU/nLEXAcTy3EiWlATIg5zBORVBDUKO0y9X3Q+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723682785; c=relaxed/simple;
	bh=MFpYAqAur2CBTuwezZFu2fjaPugZ2gH2Pu9bI39ap9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SAEmJDuWH0BhxuW/S6UHhoMRs/Gy/soDPi5hyOAjaKBoAaEaD+31UEWQWmuTq1osdiHplEMZV6QcKmcyGqYb1NQrGpfscQ7G5fuV3stN1XXijllLN+6ftVEDidCKgk53l+rBFwPoyXQRf0q00vnOSliHaaNbUJVzdpdjPUPkngU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=McfBG8y6; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="McfBG8y6"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-70939a06e52so22810a34.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Aug 2024 17:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723682782; x=1724287582; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C7eQNG3qJiwvs9MNyrho4kKV2vMWG5TUUcItl6qZj48=;
        b=McfBG8y696vy+wnsrl7kwWU0ZTLpJLZsQQRltgYGMYZQMnr6Wp74l+zcG58Sb2fgse
         DqYZsnu1xKNDIgL/0oNDy7g0tESmjTmGpCcprw+rPqlRm984IGaLcOrv1diMsxi3EXLH
         oL8xfxbVo0dllXNqBcMD352ZUs3rb8B6wwZE4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723682782; x=1724287582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7eQNG3qJiwvs9MNyrho4kKV2vMWG5TUUcItl6qZj48=;
        b=g6T8taWUPxjFI+ktaPUFzMfpOY46jUp8NDK4tw4HvaJo+/4Aug95C0Nz07ETlXvlN2
         CtUJFeg01hno7229695VAAzdSWVROSEq62fCXXhsb1V7MpS9VnRqtbGMd4+uE2xPW6zc
         S8yKn/7sObYWgfYd+UeAMmN6XvhHaflHOzphk1LnbfY5o5mWunc0lSOvJeNl+2cqa9xD
         l3frRBUFy47HB9jLM5beaG+rU5H4Yby/I239CPJRnLcGisVAyVbw2sgKfn6UNU6iWLdg
         FVy++YPr5aBqxffNztiDB+fD2z0yrPx0/uEdTzls1qpji5lYGyLXXQcD0P/CGOR1Vqq2
         H1Mw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ1IY0ARol2bVEzHfHx/XWt+qfwcgOdIm+G4ql7WMZ1y2oci3SgnIysUwuCfkogKtHU300wGnylD4FUqLEkuzAZZL9hMpg
X-Gm-Message-State: AOJu0YxnE5Imd4wyaDkbsHx4/EdEI16RHCGUxUVGTQ4Quv3rG7xWztFC
	KwuMaM2a5oZemUFc43jIXYjYA87CPK9JNKaQ3yvlkB8tMEeQNxd4oi/eKJ6yQQ==
X-Google-Smtp-Source: AGHT+IHSVf2Ro3Z8JmcPhwCQkLbT2k7ksoTCsp6QSWAbLA5ZEaTIF51XkrLoFFWSu23YtxtemeDyEg==
X-Received: by 2002:a05:6358:569f:b0:1ac:efb0:fb3a with SMTP id e5c5f4694b2df-1b385aeced1mr85394055d.2.1723682782595;
        Wed, 14 Aug 2024 17:46:22 -0700 (PDT)
Received: from philipchen.c.googlers.com.com (140.248.236.35.bc.googleusercontent.com. [35.236.248.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6fdd9072sm2165626d6.15.2024.08.14.17.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 17:46:22 -0700 (PDT)
From: Philip Chen <philipchen@chromium.org>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Philip Chen <philipchen@chromium.org>
Subject: [PATCH] virtio_pmem: Add freeze/restore callbacks
Date: Thu, 15 Aug 2024 00:46:17 +0000
Message-ID: <20240815004617.2325269-1-philipchen@chromium.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add basic freeze/restore PM callbacks to support hibernation (S4):
- On freeze, delete vq and quiesce the device to prepare for
  snapshotting.
- On restore, re-init vq and mark DRIVER_OK.

Signed-off-by: Philip Chen <philipchen@chromium.org>
---
 drivers/nvdimm/virtio_pmem.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index c9b97aeabf85..2396d19ce549 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -143,6 +143,28 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 }
 
+static int virtio_pmem_freeze(struct virtio_device *vdev)
+{
+	vdev->config->del_vqs(vdev);
+	virtio_reset_device(vdev);
+
+	return 0;
+}
+
+static int virtio_pmem_restore(struct virtio_device *vdev)
+{
+	int ret;
+
+	ret = init_vq(vdev->priv);
+	if (ret) {
+		dev_err(&vdev->dev, "failed to initialize virtio pmem's vq\n");
+		return ret;
+	}
+	virtio_device_ready(vdev);
+
+	return 0;
+}
+
 static unsigned int features[] = {
 	VIRTIO_PMEM_F_SHMEM_REGION,
 };
@@ -155,6 +177,8 @@ static struct virtio_driver virtio_pmem_driver = {
 	.validate		= virtio_pmem_validate,
 	.probe			= virtio_pmem_probe,
 	.remove			= virtio_pmem_remove,
+	.freeze			= virtio_pmem_freeze,
+	.restore		= virtio_pmem_restore,
 };
 
 module_virtio_driver(virtio_pmem_driver);
-- 
2.46.0.76.ge559c4bf1a-goog

