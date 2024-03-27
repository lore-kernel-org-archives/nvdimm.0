Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBCA1C5ABB
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 12:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543604; cv=none; b=Y4B8O6h/exGDzY7QPybtDcIZNS3k6IO6PpLQ7GkPgI9Wlh+ne/f6Y0Ra4CUqigAnrLacWjWhm61eO7/6rFVpyvbF7Ob3G5Tm/qZO7Q4IPhhqZx43YCFO0GUkNzK1vMo9/qUs8JMOu/Qas5a64lRnUO8ga2DDoH/AfzkTrjexdQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543604; c=relaxed/simple;
	bh=+b7HD7blN2XR0vp569P7KUgZ+rP9RZRo3/7Ljc6RdPk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gd7DEyjVvn7jE5unUkyJxQiObhcNke6PqXIlwNPKQEAOGP0xy6xjS1Uy2MHsMDYMFOvUt+cY1NLARzUyGVOs0CslecPDl2gZsLshohrGFBWBOTNj0vyBzRUgzOglj67s2wJ1i2luW3LKRSKJKlR7bDgLDxedbQP+KXMAyyCcd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X9r1ulFC; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X9r1ulFC"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a46cd9e7fcaso807565366b.1
        for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 05:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711543600; x=1712148400; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TImcoBJxfXGIQgqj3n4MKEXII2pXosMotms9pHsJzXs=;
        b=X9r1ulFCNIMPRRzxAnFr4bobB8u1rU7yjhrrPijS0PtsqmoZd19VYQCJaPyQt94xG0
         h/Pw3ycq0GfOZrbOK7FG4ZIadYXLSvKqgFAMahqfQtccluBm1HD0oD84aiwO2tyWAtKv
         23grcumMleSERGek7u3r182PEX4jVQwAiNwQsFszDkEUNZFQvra1gh/tdwi/30tuJ407
         u5Z1ftyM6VbalJIrERq7sdKb4DKTmCdK5CrHuT3R1XRB/UfsZxW7VaZ9A9XqntwsUC74
         Cq9KulzU4wkSTVvOkJPHxYuOIFg+++xkZ6Fw/3aCRz/YXIu88+AhQi/4bgTjwlvtwFGH
         RAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711543600; x=1712148400;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TImcoBJxfXGIQgqj3n4MKEXII2pXosMotms9pHsJzXs=;
        b=GXYAkx8CjcT9bGRBHt5bdi/BiwWzITyyok6YvvvCkInAaEhxpa/4dFyo6pYsA2m1od
         rWor8crHVQbg+8+1+Cj+EVhxR115tKNUDHNhdpOZjckGnoweQi8q1R/hxrfQuRf+E3RA
         GrhCMc6dVTrU6xcfxG2LtseRBW1jkEYh5rx/I5yRBhqDboOX8qu8DAu1jUIwNor0p119
         yM795VHvFM6x011ypbmW2b0r6iqbZJmFVkPWu5ehefiMQoxYHdnZfu9K4W7/aSvENNND
         yKDmn3rKXjxG4bqCfY9PKwskb1TunTdrXISvMYLC5wmFKYWj3VSqT00IWpX/4ErWDqzu
         HasQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf7XozAvXG5OxUs1SQ768Df+iEKw18DjYtSiK/VGWogPeatp4Py3KevqzfY8DlfJMqI0IwUhGZWj4uVvld8ReeXEiHg3jX
X-Gm-Message-State: AOJu0YxVOMxNxN70RAvhSLF6B7jfWwLcExE8CBuwNfUziGNTpkPKVwVP
	DIKMFUzpM+xVh/vVAcg3GLg6OMkewDJyckY2CX730OjijUOIDO37lQysiUFh7WY=
X-Google-Smtp-Source: AGHT+IHz3XNCa9vYxVdXv7C592UPDYjRtJdl/QW4qXpaVGK+f9EGoToWDlCo1tr4K4SuiD6SS2oOpw==
X-Received: by 2002:a17:906:5847:b0:a47:1b77:7c4 with SMTP id h7-20020a170906584700b00a471b7707c4mr907960ejs.48.1711543599897;
        Wed, 27 Mar 2024 05:46:39 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.206.205])
        by smtp.gmail.com with ESMTPSA id gx16-20020a170906f1d000b00a4707ec7c34sm5379175ejb.166.2024.03.27.05.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 05:46:39 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 27 Mar 2024 13:41:12 +0100
Subject: [PATCH 19/22] rpmsg: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240327-module-owner-virtio-v1-19-0feffab77d99@linaro.org>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
In-Reply-To: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Richard Weinberger <richard@nod.at>, 
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
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>, 
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=768;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=+b7HD7blN2XR0vp569P7KUgZ+rP9RZRo3/7Ljc6RdPk=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBBPqAdq/eg/PtMCEKo1gva2x7VgdnMT6C6Tep
 2wGqe9FMdyJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgQT6gAKCRDBN2bmhouD
 1/TJD/4qOl/HewPvOEL3qGcOWPCkSVABYFtSCCfDob4NTUwAYOsNZXbH02ywzlUMcBk5kU1U06e
 AkckuKvzdO/5ojXTRYDkDVHSyZ/6w/2Zete946WspuC9senP7Ez3D3YkNyAxCE+Sk2DVkmiCf2E
 CyINMhaAkygs+ceOFDbHwFTbo7vJVRYCTGaGRm542+GjfTkvYuWVg4xeDHg1ogRagShb3QsonMJ
 iM7hJlEEdxsNQj/ThY3v2hfTnTAx2YlEu+KeqadqilMq04KLM5rus3fTej4xY0P3Ne5G0IffMH1
 EveHiww1oViKjbvjP1s8KwwzV/hlVXkuLkEpSakHpjgTxlrBqrMB2RUdWwPDNaH/T6cC0lQxSHn
 PbZ7RdLNVmu6v4LPR9S1ncpMO//afg+3LNsPd20FwxOaCv3IEiUwKRbUqxkbjuSQH4iwKR6llkU
 IGcF4f5x4/q+EXK6r0Foa98dU3i91q5S1y0X+Fsyceaza2rKKZSTaxY46atCOCfkKWuYH+5+Uju
 5UESG7t+HFinMBkI1h6Qjkyrz93J+YOK5IKd6DQYtK0YownJLLGBpupYua5HeUemtn1gA/b+4ci
 nrfmHTqXJfXn1sKxAPG+3hj2jFzFA2Ibj7vzIzNYNdcpR33XtvVIbUpTu2kE3HPXhlMaJh18Nxt
 9eoqc6/7NrkIp+w==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 1062939c3264..e9e8c1f7829f 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1053,7 +1053,6 @@ static struct virtio_driver virtio_ipc_driver = {
 	.feature_table	= features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name	= KBUILD_MODNAME,
-	.driver.owner	= THIS_MODULE,
 	.id_table	= id_table,
 	.probe		= rpmsg_probe,
 	.remove		= rpmsg_remove,

-- 
2.34.1

