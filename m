Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54FA757EF
	for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 08:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874690; cv=none; b=q+1UQgYp8eg5mEsTXGV/+Rjk0tiTF3cBKsXO+PUzLkXYaIHJkNst6wdQZrLUK0/GpGn3+Utht7pO0s1kIjPQwbZ5uBEt/gR8ppyvXUFovzHK70oCBg01DsKbxQrhLdNf1ft8OmeuQw8cDTl+/f2DWtidKDnDWLODzy/VHK9LRo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874690; c=relaxed/simple;
	bh=wAjyw+8BG9Q/VwqKx0H5MhNDfrH26X7x79bC5lwKCk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OLTtVOFOy6w5kUG+Ao3x1JIMNKf6JFB17tV3r0Ui86kZWCjukYtgZiFM0+dOrJp5rY8crkgYVK84OEEjaydPmkT1zs8T+CrPfBG7G5XM0jGt/uGcnnpxOY1c9TeoHHoeJZwHFKUbpzXNQ6oUhO5iQpJCBwL9aOfYxzYeaBTCzBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M6AOj4C/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M6AOj4C/"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-341d381d056so2156309f8f.0
        for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 01:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874686; x=1712479486; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shrdZmoV/+LZqwehvxghCY6dk8UPLlZrkww7U3AfLpA=;
        b=M6AOj4C/ZF/0vwqrJOh8MKo1dqCD2KkRYS94dXctvscviJcNjKx5pKSp2C3ZDOZStI
         Jv9ccEdSXpuh8EFaeMNVoAlQLGorEFtXfOb/c5tP+mtk8ocXCV6Hbtkm8BNhhA62muLZ
         TV8Bfzat4OwGOsZjguSdseDxQkOsmHOCIUOajnMBsCsSmHb1od7ptNEoyUIIxqmoBtf7
         vUAmm/vVIp9kQvFhqeJUtxQHq3oX5dvNGoddWv+Te1buWUoej3pDMswafgzQ6QUMC77n
         qQmanZ10uwRXCcKsidLEnz3ZCDmfHpx8XTOZX2PWuoBZYK27UdCrGKs2X+rEC8UU3NO6
         gAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874686; x=1712479486;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shrdZmoV/+LZqwehvxghCY6dk8UPLlZrkww7U3AfLpA=;
        b=gz76IDpAQEtiU4/PPAoAlUN7ERQsVEyzrjO8H0r/EbUCERPplF7Ct0tGanTwzMdX8W
         zuvOYk7bddUH5+Q4O0WkFuKOJhPBW0DlfxWf65CbuqKI+Nlb2wfDm7RfsqErXh69vljP
         EsHXeoINkktHoVfnzL7jmSN6zBpweFG9iubdHP+Td0LC/KlfoziSlLbElZXB14MVN/9V
         Pc+rz8mwCJeYbaPq2NYESyVt7HA2ZH1eKh1nhP9q9Sb/wIhjXEANKUHQn6uTgWsubbgy
         HwaMopeV/ay+CLXuUJrF2eZFuE+a5WD7jCdRk4PNXSzeIKa1zeJ+SllDMTMvZb13gFAO
         Eb1w==
X-Forwarded-Encrypted: i=1; AJvYcCXdqDcMf9It99yXXV1P7B9pwFQ8yNvnLqG59de0z8JQfl3Pq5yrp2xcOcIQr3EJp1RUXYLdKkCpafheRJdPovTOpSM4IfP5
X-Gm-Message-State: AOJu0YyesKfxir3EYxoQaHg/yAt5ubjJpuqJh44EJNQFQUPltHrMJrjM
	EeSA8PH2Lk/TNzGx+9YjUVzYxr9fZkPTRJqB9CQEonMZM538826SDXK5bl2w448=
X-Google-Smtp-Source: AGHT+IGE3mBHpk2iYgCZr4y748sr+z9cCqPzcpXrC7rbWUuwjwgJ1DZOI40A9D2OMrxW16aiemUNVw==
X-Received: by 2002:adf:fa43:0:b0:33e:d68a:7d42 with SMTP id y3-20020adffa43000000b0033ed68a7d42mr3902796wrr.30.1711874686293;
        Sun, 31 Mar 2024 01:44:46 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:44:45 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:43:51 +0200
Subject: [PATCH v2 04/25] virtio: mem: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-4-98f04bfaf46a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=785;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=wAjyw+8BG9Q/VwqKx0H5MhNDfrH26X7x79bC5lwKCk8=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJTSAIIgTimebstG/Qy7uAfSArMFyh2juPUo
 6ZPodVLBXKJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiUwAKCRDBN2bmhouD
 1xDtD/4z5RmDFqjWll6kjvhDzAxQrcOG1NaTdWTMxysEd+H0xrvYrwZ47DKXPkAUiIdSBZbN+wM
 vueRYnxKlobdHqQt51krKCLl+ShScgF1bRuBVLLEK9c0R9rXygVdMqVnmYUOzjgGI5AP4dK8hd3
 /UxxdtXu5ezHuGb3vXKiFiVtZuTorRjWXgX5EfYg1qmNq0mZVLnzQjPl6hk2eUwnAyzaNAHlWkP
 il+dRt35QvwCmiKSxbsVvt1xUw2O58H5Ln21w9RYHg9yaqD9r9biAKNT8hz0+OhQ+csGBzb1qNQ
 Yy0/B2aVcnfNoxlvU/3B0n3IXe/94fTVmCGaMutYCGWUd7mmtXBPLQHQigb7XF/WhI+H3ZlhQ5j
 9iPp98vj6pSGuwWtvf1vAmWQ3C7hLch5jnolS3lhEb3Kr+Mzp7FvMpBPkSPapmaEoXyMhD9aFHS
 plVjGY0URnm/4qINC7B0fqXMQf5XKv1ozQF6C3ea3p8LZgknmtkiQGJOQjblgGJqwugh2zyhUBF
 9bx7ZBmQgtIz4A9IbAP5ZxYy+9ZZCD5dPZe4Hrwc1s2CGw8Ajpl8CNB+otZFRPRor3W0vF8G+hM
 dPJ70z0cLIp74sE/i0MtNiKtmuqVcPtTD2ASbduSMGLBpM0o4WfdMTlVFNjz4hdDGCV0cAgC34+
 RVnhiy/vQaspgfg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes in v2:
1. New patch
---
 drivers/virtio/virtio_mem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index e8355f55a8f7..e605d906639f 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -2991,7 +2991,6 @@ static struct virtio_driver virtio_mem_driver = {
 	.feature_table = virtio_mem_features,
 	.feature_table_size = ARRAY_SIZE(virtio_mem_features),
 	.driver.name = KBUILD_MODNAME,
-	.driver.owner = THIS_MODULE,
 	.id_table = virtio_mem_id_table,
 	.probe = virtio_mem_probe,
 	.remove = virtio_mem_remove,

-- 
2.34.1

