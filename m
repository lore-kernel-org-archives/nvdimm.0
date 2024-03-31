Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70AF1494D0
	for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 08:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874787; cv=none; b=CNbTQai9Li9vpPCHdb+jMBvWcnLrnsa6Sw62OOdayZrvy2EOORuD+rkishh/IwY7em2DQ5G1mcnm2OaHcvclAPQW2X4J0mWVEaRqkY56UtTlcOcZH+LHacDNwg1qrq+P/80Fu/OVeSBujpvQqax9N0/m4GPXfKe+OeQho6m67/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874787; c=relaxed/simple;
	bh=ZZgxTq79++b7HHq30K3VBjFNBWdk1QKSfVGAvnwx7/U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LqzSGdY+FRhG6a21jSgDqXRKFoYXKatWDrQChxqf1r9qn8sdLCR+SRFjKzy6e+H1HIevJNjDf0j4AW/cL3/PxJq7pNs3dclmfEpepw/7iTG6WTkldbIkHnceqk4dGu8sAaqGDUN5KFZekYJG8/Lzd47Cd/Yzfi+FwhFiGQYhAKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yAE2b6Rm; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yAE2b6Rm"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-341c7c8adf3so2221859f8f.0
        for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 01:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874782; x=1712479582; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PUGaKwdvwMokLlZR31UQgBcIJ2q0krEU+yZMO7QbwcI=;
        b=yAE2b6RmecbiOUogrSpTpmgF1m5ZTPs0ERLcqQLmwDvQXNpmRwxDEaDR4ookVRwlxs
         hyIRsPFjj//c8eGIiYo8VZ6XsPP7MVXVWgTslAuRrZhY3s788u7zixUYjRE1BrgIpQAs
         SYvM8X1CIYAPUM1wXD5Eh7l8fdYV+geN+F8IDjGFIHpmSeYTndV/02ligyRNJslo66xq
         yM30lwTX2qYfhxzHHqM30eESEvvINU7CTpH+YjJ9X9Jksfi4gMecuhYdVrm2TrOeK5lL
         iWA06pYpq8RmXtFLiVX5s20Uvjmg1KaDwmo5cup7a64Deb0h/BHOsmK9Oh2CVEG1O2HZ
         z2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874782; x=1712479582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUGaKwdvwMokLlZR31UQgBcIJ2q0krEU+yZMO7QbwcI=;
        b=McmTXyt4e0Uj5WEp15sGyDM75jXSamZ3ZQXN7h8vgT1QBCT5EI0y1ri6De1Pk++5CL
         syDVKy0ekh5QwHYU1ESEdzNiGSsYkG/7rDXA0gmlcv4E3U/Rc850eIRgi0VKAsa6E0db
         PJTNTAJXOLer4xFBV5hRQ7Pl3UydUgc608iZXVxODPFUcWh9EuxCNWlmwbAF1O9wuwdO
         zZjz5BZyzxEtFIDvSfa4jTzMoQ9tzQUqXkc6AXsPxEvz1V0dsR/e+xfI5uZXE0yGypQS
         dq9T7MZqsvHgv/0Nrka+KMZ8KVmulJBFcPJyMhJmQvxdzM0eDF5XKGS7D97d5mq5KL+O
         VuhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhUWDiNvevIxveQH0txyJLJsjaXSME8DzRl9kJkGuMXGS7GUBS9LI6Kb5Edzt441kjpPYYfFQjRGAESch/UeFZd0VzTXWq
X-Gm-Message-State: AOJu0Yz3ylJ+2TILuhx6jbLU1cLM5vAdcG60oPXQ2PoKzqyjZPx9YiNi
	Qd+g9KkiJSptSqVQLmuCJRKgnq+JQHOfFSxSt77hmiyCS34KIUFVs45Nd7Nv4As=
X-Google-Smtp-Source: AGHT+IF7MARc7H4ZqzG7wJkQ89qaWtgYzIyVWgX/basw0DoDqcekmy5aXwgVIVD/A5uDZbyMRmIPWA==
X-Received: by 2002:adf:f88f:0:b0:341:d2f9:494c with SMTP id u15-20020adff88f000000b00341d2f9494cmr3575737wrp.55.1711874782419;
        Sun, 31 Mar 2024 01:46:22 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:46:21 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:44:12 +0200
Subject: [PATCH v2 25/25] sound: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-25-98f04bfaf46a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=719;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=ZZgxTq79++b7HHq30K3VBjFNBWdk1QKSfVGAvnwx7/U=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJm5t8lRjxPTys8b+WU0OKgg1LgcvzKJ4xNt
 n3OV06BuwyJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiZgAKCRDBN2bmhouD
 13W/D/oDYwucjXt0Tt8Y0Uy9LmGcrAbjofc6FyMbOg5ZcMm5e3+WVCaJvH1GzuMW7eKutG1NKq4
 SG+22VBevobbwXkTrzQkvyrydccLRDbeWLWm+HJad5tojpoFvW83SYI4iPlD0b266lNVIdzpKjz
 hcUgfDLubJvg2WN81urFjglAG74SusSyGpct+7+xypg9xUvAMj+j+vblD6MiYvdlR7YTT07NpVb
 CnsXjptZ5D0mdqdAp/yyZAVgxH8IatToMVp+zeRzRlVPHc8mepyeo/z9irAjfvJMoh/GGv0t6Gr
 6lHVgN1q09NOsaKCBvZgBc1M3JNDSEvRjO4LMT7dAINa97EQdIp9+8ZpNqqX0RQXYDulXZIS5+F
 Fi4LuIifmxFvnLlK3XGafTiE+izB6Av3JwLIwcg0Q9VTwxzmWeoDKL9c1o0P/bZ5TzBsp8cO5Az
 EQrw4GwFCAMD7jfVzip/IzS25Sgb5lVDNqj2sWyi5R9/l0bzGoRd8h0nMUo0h60LV8+UQNG4Qn2
 Z5ijAWCJJVA4mNoA3tp1IfoltFnoxAy+WhGYLKaLo80DfbVnlQAHuwY8P4oIqsfEalA2ZTmhTBx
 qz3zO+FBApnCfqIytRnVYYYjPxsP+kbjFVJOBhR1fGzSU1/is2cPkZduK341zXENT6nHwkNDVK4
 VB34pc8fk3aFIrA==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 sound/virtio/virtio_card.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/virtio/virtio_card.c b/sound/virtio/virtio_card.c
index 2da20c625247..7805daea0102 100644
--- a/sound/virtio/virtio_card.c
+++ b/sound/virtio/virtio_card.c
@@ -438,7 +438,6 @@ static unsigned int features[] = {
 
 static struct virtio_driver virtsnd_driver = {
 	.driver.name = KBUILD_MODNAME,
-	.driver.owner = THIS_MODULE,
 	.id_table = id_table,
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),

-- 
2.34.1

