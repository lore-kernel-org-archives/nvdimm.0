Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD1212BF2E
	for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 08:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874699; cv=none; b=MIhnAqB4Qtx1I9JDyHuvFzfW3Dc73VZuUF7/oJ5og47nY9/YWPttd01Vqq3iroWbnEnRX2hIZw+L/szJKbOJRKg4N1+Hv1ej42+ZRCbMJSDVkS4u6TaQa29t3iygdeq7yzskj+BIjAaQrgV1GquiAo9fZzNl3PVG4pRs2eEgaKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874699; c=relaxed/simple;
	bh=KrWaLvXjNRGS2R/7/B1+JUwLcklixu9aLwMl5ahCx2Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SrKcah9YrhqXFwJq1ur1INgwCSmmvdRhFTfIusvaf6p0gN6z/LxWu6IQpMp9Iev5awT8YM+s4emRgzM6UDyMBR0dX9Ltmtd/9YL/LOgpD4ihpSdQVC2WvBWjn5V4CXrwScGVgC3ToeJRyV1q3P/Yl107SGF9D65ckDgZsTj9+yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FUXBlLOr; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FUXBlLOr"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-41563039a7dso446235e9.1
        for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 01:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874695; x=1712479495; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eyRMm/wBFZCWNsLJMI0b6MGwMk/UDF0WMd3K76wQcuc=;
        b=FUXBlLOrt3T+p5lU2Ct6T+FTHJv8zjJoRrICPbJ7PpM3a1W7AKvvarYsHdi807vISm
         cmArSp9j5KbbeKC3HvMl6hiPuZvBHBJPn8ujEhEbaK9J4TD09CzBz7xc0h80T3ggSS4L
         zfcABMoBSz6PNkW7MQ/walBa3FY1CDsQvP33Nhkj1SUJcUs498MJ6Gi8JTst/YFhJzhJ
         F+NjnnBaGOg5LEV24gq5vVcCgHe4LiCFpZKc9dGgJXHxV2cCwFBmD6F0VMM4LYsbhPCI
         6RoJRRmnNsKy9QrPtXzLYaMP4QzvgMm6SQ8cBv8iiPgA1SNxxhMo/SDJoTgpud0ciX/Y
         4Clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874695; x=1712479495;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eyRMm/wBFZCWNsLJMI0b6MGwMk/UDF0WMd3K76wQcuc=;
        b=mieMOh5hkupqh9LHBRrCzwf++C67lCWTfri74H5RYWFsroCdeIBHWrXp2WLT4Ts0of
         h+AQ/kcTnDVxG1MFkeIzQyjZfekfE1iTaWLHRluPXmTJ5sIqeu5kkfj/1nDa1vw5RlC6
         fiEvMpru9s7jArcQJd47WtkxPqlxwfS6P+pDvWcS4oA7pMKhGx9HcedTz2oO5U/LzhxO
         vW6UNi14wvKv4bC5GLTRHJPV7WNT1EggLhhAc6i1b8LEqWqwyhGK/qRLVvd8ofG1fhpJ
         U9Ns+jvy3MFvw8ICM7AZZVQXF8Trxgxpv2SQxgz8nMovTU5rP1kleJeYkngAycMFX+8j
         kS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV0M3NwJRijsBjrZ4fgXNo2xOSXAtGUBGzEcsokRaM5ksi9EGOGw2gm8dzClKzu58ZrveN2fgc4bis7iTUZUOkto8kCPRqd
X-Gm-Message-State: AOJu0Yxyg7v8D82MoK2KJTVhnJcfrrfFcCP46mcWE/tRWo162GsrfnUV
	cT7zntmkLXIu/V1Q3SLDg2/hxp9D2fWXX7KXODHeZ97wNhej0kCR6fO82uLVObI=
X-Google-Smtp-Source: AGHT+IGACNL4bJrYwx0UztgLHkocO7cRlSfm5YEfvnab8zjJOAWgroG8Si4+SOgexI9qnY5FfsuBdg==
X-Received: by 2002:a05:600c:21cf:b0:414:767e:6e76 with SMTP id x15-20020a05600c21cf00b00414767e6e76mr4893865wmj.21.1711874695710;
        Sun, 31 Mar 2024 01:44:55 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:44:55 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:43:53 +0200
Subject: [PATCH v2 06/25] virtio_blk: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-6-98f04bfaf46a@linaro.org>
References: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org>
In-Reply-To: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, 
 David Hildenbrand <david@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Jens Axboe <axboe@kernel.dk>, Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Amit Shah <amit@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Gonglei <arei.gonglei@huawei.com>, "David S. Miller" <davem@davemloft.net>, 
 Sudeep Holla <sudeep.holla@arm.com>, 
 Cristian Marussi <cristian.marussi@arm.com>, 
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Daniel Vetter <daniel@ffwll.ch>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, Alexander Graf <graf@amazon.com>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, Kalle Valo <kvalo@kernel.org>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, 
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: virtualization@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev, 
 kvm@vger.kernel.org, linux-wireless@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, 
 linux-sound@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=774;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=KrWaLvXjNRGS2R/7/B1+JUwLcklixu9aLwMl5ahCx2Y=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJVZjvxVp+IeLHj+IFo/zsUA020KvJ6wRVqy
 okF0tos1aGJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiVQAKCRDBN2bmhouD
 11NOD/9bfs5h1GsEf7ulvr0p0JOFXciYxQWCXWYoR6UZ5Y1NWaTZV2G5P+aRmwsBC9m7f3RteEu
 LFFTsbIs4xPoFsUZnvq0EPN1ZoJlw5Lu+lCdhTOWE+/n9qRRnjiZMiZkf6co1scBlDKZZZiJJc/
 8aitfQ7rvN0kKKEfpD46vPy9sil2Qb4SdeCT337bpfJfX5KeMGCMIFRqr5Yqqrq2n0CTb9fzkCV
 ClJTNckXdrd67GbNc8Eovl9ib2M+9Hd3VGxLnGTXBulerZZAe+RlV4xNujaXSHOMLNqi3tk75fI
 cSCKEmU1uzPZNa7imkkSDGf/oitANw7AzhWH55TsJksAuuIgOjcmsVkaBPh5QeLE9nNKFP3aFoz
 2i/DXpiWy4/MDqswsZTJSqh1cGHThiakPD1e6g7P3qXi4taSDEmH1nK1jKKyYu2IAGLD7NY1AGN
 7TA1bOH1Gf/5fQ25e7ABSm2f4BP39YDYMYUKHwX/mttLEcNek8vxjL0VWAGUH9e9yDj+Ava7FeR
 3AWJYYIIDGfAX6P8ZCKw+DcuRhM0u/wfyRBDiKyDjLjKIe8EWDds2o4DbcKo4BHT4/K7a5Odwah
 0Y3ytFsh4TleFSZWzYanuxhyDxjatNAksDPlUlCiBH2EpNQ0CpjJ8WqXdLJbXEpkp8i+W9PhI1t
 z5LzaNGlz2he1Pw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/block/virtio_blk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 42dea7601d87..46bdbad1ab48 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1658,7 +1658,6 @@ static struct virtio_driver virtio_blk = {
 	.feature_table_legacy		= features_legacy,
 	.feature_table_size_legacy	= ARRAY_SIZE(features_legacy),
 	.driver.name			= KBUILD_MODNAME,
-	.driver.owner			= THIS_MODULE,
 	.id_table			= id_table,
 	.probe				= virtblk_probe,
 	.remove				= virtblk_remove,

-- 
2.34.1

