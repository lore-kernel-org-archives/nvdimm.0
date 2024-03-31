Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557061442FE
	for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874755; cv=none; b=kE+PyKZ9SOcZ2P5X1s05eynZO4NhugtZ/CXrJQppyqmU3UzaeVQ0aka5sb3kOMdKV2/AISWN9YmUq4jIQpQ6/UWWkN+zsXJ9tvet3Enjd9un3XaCs935OqeEZ75PMjrkKwDZklFGw84Ja9LWO/uGG+xjKd6VSD/7KkrOKAJAceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874755; c=relaxed/simple;
	bh=JcKhWFch83brhdG0VtzetHVJQ40R24YKIvpYHZtTLn8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nlyPPhrMa9nEwyrFCJ82kCyh5bPD03wL3cIiHJ9qi8rj/YXCUBxocA6QnjcoTldOJZILxybUJjvWp9MLbh/CE7BxRGv0RyvptjvAZLMVYOOOh7IYJmLXiNZ+W2mxGuurkpQpliUI/30IG4VXrc9dnB+FtxM76YyqJqsz7Qss3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cGaZkFz2; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cGaZkFz2"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-33ececeb19eso1933251f8f.3
        for <nvdimm@lists.linux.dev>; Sun, 31 Mar 2024 01:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874751; x=1712479551; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DTHQAQAXVP2yHTVyN3Qf81PY6hYlRsflmkOJj4KRX5A=;
        b=cGaZkFz2fa9oO8hWu4VZLEPLi8/pog3WXerIpuhWJFs8fjhtS0mEsnZmdf5ScuW27U
         VdiSF5QvcBe3n6bhzt4z4USKBd9BJdF+IxTB4Hx0kh868FcGrc7RztOpelHnuV3ZYVQt
         nDkzrUSKz5PCBSaZeilI3OVTYIgtdgbQU9nn9YYcGGjpuxQ4UGgopz+iBow/QYQGje4f
         KEisJc9chjZf3mBB0g7nm/8efXcIiHVbcf2pKCyfMh7RWNkkvYtTwIagnuUHAmbvCZoO
         JAfiv46BplRh/57LZoRrFI3FOXJBPJL7Q0xEvS6KeKn9J8YzVx51Y5VywDO3j2SXMCCu
         GBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874751; x=1712479551;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DTHQAQAXVP2yHTVyN3Qf81PY6hYlRsflmkOJj4KRX5A=;
        b=bLUx+D1zEtdD9vAuhwz59ureHpAbU0tb/UrLqPheGlBI/m+ok4MbbQlms7tPaTj0eA
         H2oMxVTyfPvIJx6SmcVuc/5sgRTGSbkNr4SlNkMMEXC4/Vqv5ezvepcFuLT6gMfMuGCB
         3tKBcNiNUNuwLc/AKiOVoMCSgIaYnzFZatPw0bBRz9cjfDYG+S+suKI0w2jq+mnSPs4F
         KTG4uZuUK4IUbLPrukcpyvJ//ByPV7rX0TF87IoFEIfo1Nrjeu+E1aBTsl6s8gq6v5Cl
         1ZEMFFEUkYIDMV7XwGiCGNpf0zYmE+NLfKsll0Rx0bNJQeQ6HONqSt8fh3fQ7lBXqAKP
         pchA==
X-Forwarded-Encrypted: i=1; AJvYcCUNLhxEhKb1FKHebzq2FCVE5V5YXqvE4aq5jR0h9G8qAKBOwzeqlOpERH3nafCoAm89xCaRebkpi5fWOumNVAzvh6sbs8C0
X-Gm-Message-State: AOJu0YzEa3DACLQYS6EWVYybFx19S6zWurRfrTqNrfI9fYsijYzmUR46
	XFW2nZpYowyjlbxox1n8gDyu78r1NDBUY+RD5MFfLWHsSxlJ5n0Ao3N11SfJA74=
X-Google-Smtp-Source: AGHT+IGeuGXiCbCJT2fwDI0SEWizUJ9iibgMGqfwV7TaAR+tREdoNJwDLyVfYi67Bn1T1MJNDldUog==
X-Received: by 2002:adf:f804:0:b0:341:ddbc:fcf7 with SMTP id s4-20020adff804000000b00341ddbcfcf7mr3806166wrp.1.1711874750824;
        Sun, 31 Mar 2024 01:45:50 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:45:50 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:44:05 +0200
Subject: [PATCH v2 18/25] net: 9p: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-18-98f04bfaf46a@linaro.org>
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
 bh=JcKhWFch83brhdG0VtzetHVJQ40R24YKIvpYHZtTLn8=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJgSqws1ddSI6zt8bZXVN2NyD1CLEpfewZVv
 OwoagjJv6qJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiYAAKCRDBN2bmhouD
 102lD/wIvu7W4oAOrFSz41pWQt8EAwtItoVXQB9hvcjw/YA+2zX+aydeb02+0qHLAQbGNHBdxfc
 yT1jMBjqC7hm1u0RTSxBcbJJzGs8e2DQ5Vhp70FBMhH5Suzn68J6dOPX6N5wHdff75zMWr9dJyK
 vSMxNyOJ19ThsLo5G/naBdf5gD/wl7GWZ/BynkDrQeahyUwT7EAmobRBH3C58X0PJzx1UeyIaGn
 BD4PrDB3XmtMl2+8fDS+Yga7XtwImkKcCKQmPYaMiOyK8nsvmE0G5mjoqBDyuvj3DbXP5PyEcah
 8siN4HSdpwXj68yE2KgItH1tHOp6PLEId2/8rHBD1Cf8LRqYUpJOSxYFlVCzh0QFv0epWEaRBFY
 t+sVw1BOnmBi6uJ6zpDaomcniLZ7+QMb6J8kX0aGCnE5xhfvD3GSVTn0b4+Zt9glME77oY2Csxv
 27NZ0gLAatWrCnBDi9A/Xe83MKDzfdh5+JqvpcrgsnvNQamvwK41r74/++Ec+O8FElCfF/VXAcc
 ON4Fxjm+sLJHUICUQYzW8QNCnzdVMi6R+G1UPZyqrIbvxfEG1TvL3Sd5Z+A14qs4De367Wz2+XG
 1OHZrEYXkqdpZXUSnF3NgkWODrQkgjG6Fl/9xfwVMVzKxPLTYE5G/yHlgDd6baxF42Rlh2MjRz5
 eR/43u41s6aOCmQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 net/9p/trans_virtio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index e305071eb7b8..0b8086f58ad5 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -781,7 +781,6 @@ static struct virtio_driver p9_virtio_drv = {
 	.feature_table  = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name    = KBUILD_MODNAME,
-	.driver.owner	= THIS_MODULE,
 	.id_table	= id_table,
 	.probe		= p9_virtio_probe,
 	.remove		= p9_virtio_remove,

-- 
2.34.1

