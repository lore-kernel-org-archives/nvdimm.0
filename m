Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717FE7F484
	for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 08:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874681; cv=none; b=JTloICEzxHctaVaMBIGtSx/5Naga2iGdRv6ipnydn0sSYM/ZcjvXFzRrbh8dBSIai3BBlqMB72R/fixggpfXTeTmSncdroKdini+S5m0FUQs/SJqxHLR76XjpzCYByebIJCjXno3muDiYSrsljubkQuVJ42VwwNLDnn7FG1QOb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874681; c=relaxed/simple;
	bh=2Upz5yHnrh04ILzCunTBdzzxhReGAn3RLMhXlhS4dDg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kmJ2jGVYQE2DREi5reqwfDG9SH675PW4IXzvhqlhvTEvtJPzB6eXZ7+w6uPGL5PTZnoWalxNXIl4njfjzjrQt2f5TvDrOzVI9xvX1r2zeCdJg7p7xt3eVPOgUjgED55qS/0dP37bkks3QUX0m3RCpJs8hGX12/sLOXh72g0esV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uh7m233j; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uh7m233j"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-341b01dbebbso2889607f8f.0
        for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 01:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874677; x=1712479477; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8GsyJSzDMZB3KWSZh+ZpUPxiXhkF9vqYqu5y1Iq0qs=;
        b=uh7m233jR0/O4VN1CaXhcXQWdxnH08jYBXXcYV7eKEP6wA9pPqACaGYYqgxYGjW+LX
         fhdgRMAsQ6wMZnsQ8uqcbxr+ml12LmsSKsO/B33DvEG6uDMe187P1OeOQ9VIB5Yb25lZ
         Kxtn8TRhWLRsNX5THbJeSgxFyDDQdvZlzcs09ZUkX4bhG2Oka7McTBZ7G09Un6fePK09
         9RepyPp7TQWLIOTTtyPsl8uRbpfONZUvBA0WolFhfCbn/jEvsnvIqTGh7mgCbGGkMNJY
         rl+CqF9a+HIn86JyvANt27BCLeWy0pUsz9wiv/0hA9b047nJ1zKrpkhDPtr1RLbCbD9n
         kqIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874677; x=1712479477;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8GsyJSzDMZB3KWSZh+ZpUPxiXhkF9vqYqu5y1Iq0qs=;
        b=C97x7diO1jHW5hVYxWWbwmkUtk5z6GgmFy8pNGjzIkZ9Eh5aTatqnhcLDhl1koqqzZ
         95UcH7BQpCtzv4mjsmaLdAHhjJxd5ahRKDpatJHXnU2zyur129m/moGIdqSRQkHDZdOD
         Rz/1mvW+49EP28XBUQU08pm2vBsdaLERHfIx7WuLlWrQycRrofX+X3jw0RvzQ6wKAx4i
         nVuUZotdY0cUVB9bDniS9M8ROt8BZgVjbZJLjFbYVOwoKAwBylE5LRciGNlwfE8quNoC
         x6nhQ7H6MWQTA/QbTzV5Qu9ot5rkA4dDoST5Q4lkt9w3ESvi6LZjCPNoQLt5WT/XO5/M
         oNnw==
X-Forwarded-Encrypted: i=1; AJvYcCXzBJHbp7gsedvuhK2hhDVXn/gaOxACZyC0nyLcq0QCnwAG353c4+QiJtloFL0WdMwYmLn45ubKz4Po9XqsECz61N/rJrBD
X-Gm-Message-State: AOJu0YwCzftVbAdl1PLMWrDZ9hPUD2o3zTHxsA86rNebyuZHcQ3VQt0L
	WLsgOJ70Ct7seWOrFXemL4rmrzuQG8FcqyEzWDbsDm7mWSWWoEBxTHQFhNJ2j0M=
X-Google-Smtp-Source: AGHT+IHZTJIXQWmGKU9MzqOg35DEpqwe7TpnBZ66n+VRe8xGqjJcD8XSaNhFxZ0zfHKKZCPjNcUiNA==
X-Received: by 2002:adf:ed90:0:b0:341:cfd6:42b1 with SMTP id c16-20020adfed90000000b00341cfd642b1mr4845560wro.11.1711874676955;
        Sun, 31 Mar 2024 01:44:36 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:44:36 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:43:49 +0200
Subject: [PATCH v2 02/25] virtio: balloon: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-2-98f04bfaf46a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=782;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=2Upz5yHnrh04ILzCunTBdzzxhReGAn3RLMhXlhS4dDg=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJSQJQIejoO8yNYAAgfkVMeaRAdpsoFw7Z+z
 9V2NnZ7ZA6JAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiUgAKCRDBN2bmhouD
 19O9D/4hy2yeN482kQMPK2LPDLJiJ3qvGi8LefZ4V+Bj4gx7QABbW+a4DRmQmHvE9gPdk7c68t9
 Zxjw80Rcnti0mYaLtegyasPNBBuzORsLYeA5CRXDRxOdqhwlUm8tL1s6c2PkFLPrHMsO/V5sHKA
 MNyFgcHg1AnnhmrRhA1HcrgXFsU34NjJgMMESB0NDfYoTFAYN/7jHQ8/3mzTFY/ld/c1bu8qPGJ
 haTCF0P/sjAL5Ml2yIvRAplaPQRYA4wfZ8pLje+L85JPzwWRpORwD70CEnHu9cOK7F8VFYl8rqg
 gJrOM45nGbqVHa3U6DHe8Uu3k7U5hI46THDZiVavl9qg5KhpD4Ke3EYVK/X5c9gBver3x4QRmCW
 jjPIbPsIulwMPv/3p3cb1T5cDXWgHBn5/dmfRxYqi26LCCdR53MGPWTAog7t/NbCkxUuYveNBek
 zlIm/GfczAU8ovV43vEhzfZayWjK88MWhM7xGwAaEei9sgCQfKAn6G5ucIqZnlBrbjHZcQOTO8r
 3SHSfJaQfajrJEe75kSOocR8t1SrdbxmAS4+x7ee1fWrpej/migYAQoA3AHZ1r2hbzvakCNrmX3
 ZCO44YIfsBGvTykqOvjiBmD62Et9R+Bbv+kR/mDipuOxNffsJHyV42SdkPv5jZUI+vCSWHdpi78
 WN+pzsc8Ru4IbYQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes in v2:
1. New patch
---
 drivers/virtio/virtio_balloon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1f5b3dd31fcf..85d28a0a404d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1155,7 +1155,6 @@ static struct virtio_driver virtio_balloon_driver = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
-	.driver.owner =	THIS_MODULE,
 	.id_table =	id_table,
 	.validate =	virtballoon_validate,
 	.probe =	virtballoon_probe,

-- 
2.34.1

