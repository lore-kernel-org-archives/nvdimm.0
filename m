Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269CD8249F
	for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 21:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724709215; cv=none; b=D+yHga3x7oe/TfwXrh6Sw0kwydDviigbkt+rlwDvA1d0fVqtuKu2XYD0aEzZPpCzJPxCALd78AkV+bjol5TpmOccXPzxt4mVUpVw6hkjQGe1dEcVmuBWSTXdMNkxzIWBPRYiCu/pV7sqVAkebpNQAIj4zesZir5ZLfkN/9JYilA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724709215; c=relaxed/simple;
	bh=jTM0jAyh1dyw5X5cHLVRJ87Jic4NLyo+Ct0r7BxdakU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hgE+qaA4iibtUImIkpDhvHDqjzdTo9gttnRLqlAN/fVupAto9gcn6NgUjaj9P6bKcPWHQiwzUUUKnJPNXPOIM5AwOJevKeTOBJv9QlcUVUH3CbnQFQBAvHEhhw450Nhs8UZ9RWbiStIVKjSs+B6/nvDU7o8T3tiLOV5HrmwhV3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cquLHPZT; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cquLHPZT"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-44fee8813c3so28558841cf.2
        for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 14:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724709212; x=1725314012; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SiSQOaTpyXJiMAgdm5YfXRHccf2gWIyjfptOmFMd/7I=;
        b=cquLHPZTNrFOK640RAZfGXcQuxAhoIgOM1vxxkCsbdjf6xtDmOWIheysqXtvHX+lfr
         P9C5T8kc7ni4diUcaHdc2c5g1L+MtgDeCMCwJuYGTxoTgtYgz0qYoTD3HfkEeBgdoj/Q
         tU/NGJ18j+wguxDaO4mc8qfxlLgWLPW139kk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724709212; x=1725314012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SiSQOaTpyXJiMAgdm5YfXRHccf2gWIyjfptOmFMd/7I=;
        b=wN0ZE+ybeHqOQ0BxVHlq2xUve/8jPJeis5ynzSNsHum5QT/WIQAaHjxmk/NtiUtJPD
         U/zbw29yRt/GFIxbETflilAmdS3l17nKlS4z83MGNm4myhqFbt7XYyb+3EtwbGa+N/oQ
         xhubDXXBSqqPXDjXPE6TWOe4wyPhOEDNhFJfUSFoTeDtQuyrQH6nTBhdMklaTb4FRb43
         NdxUTO+PE60zf6DMHraswQSp9RtVTfHgnyPz1Kvl9wiZjDhh6L2nMzVUcNialq3C5zaq
         98mVUAhiAdMiuKJGpr+r2epbBfSN7u+dYeujrj/Jg9lK2JVoNEXBHbm4/+GTJpoaIXgx
         zDSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBl7g9zlYdSPsjhJ+8NLdpFMSW5ZH8XBQNdA7KBc2MS4o4TlopTfEkJIxnXIokpXFYgX5j1YI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKObNVUvq5i2QhruMP6m6YHz092x4QcYWxPzAdcm0VOLeirs5a
	mGUGelWa5H2lppxe0gVAIlEpmg2zaZXm9Fo3w4TqcyBtLv7YDmUhNGyFXY8Cmg==
X-Google-Smtp-Source: AGHT+IE+JAjPYPtVbxFqucyrZTzrAHx+x1/DGRvVRVS9F+m6AXkc7hPFywhHH29+pRV5Z2ToT6UMQg==
X-Received: by 2002:a05:622a:4811:b0:44f:d986:fe4c with SMTP id d75a77b69052e-455096453c7mr115032211cf.20.1724709211831;
        Mon, 26 Aug 2024 14:53:31 -0700 (PDT)
Received: from philipchen.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-454fe0f75b5sm47507521cf.58.2024.08.26.14.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 14:53:31 -0700 (PDT)
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
Subject: [PATCH v3] virtio_pmem: Check device status before requesting flush
Date: Mon, 26 Aug 2024 21:53:13 +0000
Message-ID: <20240826215313.2673566-1-philipchen@chromium.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a pmem device is in a bad status, the driver side could wait for
host ack forever in virtio_pmem_flush(), causing the system to hang.

So add a status check in the beginning of virtio_pmem_flush() to return
early if the device is not activated.

Signed-off-by: Philip Chen <philipchen@chromium.org>
---
v3:
- Fix a typo in the comment (s/acticated/activated/)

v2:
- Remove change id from the patch description
- Add more details to the patch description

 drivers/nvdimm/nd_virtio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 35c8fbbba10e..f55d60922b87 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	/*
+	 * Don't bother to submit the request to the device if the device is
+	 * not activated.
+	 */
+	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
+		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
+		return -EIO;
+	}
+
 	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
-- 
2.46.0.295.g3b9ea8a38a-goog

