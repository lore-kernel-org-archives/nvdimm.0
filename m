Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4053A135408
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 12:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543374; cv=none; b=frMTG3pIwt3mtAiEeTlFtmmw6Gsl7RiNGUtCmrua4V9751KEBpRlL4GgQEQLOB/GnXvGEuqJOw/7C59fITYdKPQDeB75xUjikVgOnbWGRuwqS1d7TFhLOAsBDSswA21RsUOU+q8rrqn2DqLQw7xzUsRGWQbXar0JxCRnZyDa2FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543374; c=relaxed/simple;
	bh=RVE008LGGmmk5WXgZGxtm6p/ays+12n/AyoNVnX9umo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SCWW9It8uklZHrMoohK8VklvxBxvqqxYGMaYcBvtvlYJQqDKDTaagAffLMKg0kOuk9fhno+cT6ob/FC6jTPyb00s3cnhIOxPZTgSivGOClYJNDTe7KooD6OjOe3mHdYfqUsUql076zI+QBpTAEfXM/Tkm38UbYWLOnXrOWBEKyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KfdQCylE; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KfdQCylE"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a46d0a8399aso142112066b.1
        for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 05:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711543371; x=1712148171; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/vBka3ABZcniwH/u8QWX2xHT7esEXtapMcD7AcTvpic=;
        b=KfdQCylEjIzVOK5klq86dDKAonLy7rGEc70EjOFZaf+czRCJ+nA7pAr5If6uVVxibF
         nCplhjsma3Jv0H0rcNjWS8Wx6pDS9DGjr5Jt24aOwnqr8BNM+NC09NuGNab1DpBvvsyW
         Yf73cbSpqPVVqneM6sfx03y0sFVHDX1uCyZ+d9yJkOQU02JflwkpciISkC77tpRUar/h
         fpHMTBCPvNHL0gCsnKCkm/aI8E3MhAl1ZgqQ6ANeTbtgTUslW3rvlZqiVhaKhtSKdG5/
         7ikVODcG15q1ndva0jYUK2WjmAbvCRxAN7plLQ91Mrrz5k+sLKl0nYbXgxBXq7LLPja/
         +m1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711543371; x=1712148171;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/vBka3ABZcniwH/u8QWX2xHT7esEXtapMcD7AcTvpic=;
        b=od2k5gH60nh/gPPClVfhg2YcB3N/bU66kIBqvkz8QxErE2v+ZJLAkJo4LoImhtt7FS
         rrg4tTYy/Clqglz11KdziCM0yqSUFDbWf/dJV0eg9X9N1fQn31dqpcMgpSKCoMBeznmI
         duQ2+mxln3I6zKjLeqUj03vTwjA4YqG/EudpcCpQ5RTqTRz8IK5wbu/thDc3ndA+3clF
         DMbZX1SCyeb+IeqyV2DHoS+hz9rscr4bZskrxC8YdtzSmxsEqdjbWxG8Gki+BGQyA1EF
         euLRtJi565luYyasH4+Bx+kY2DWGjbdAUGOgJACvLxiaVg68SZ0lMAldTYPSVxnFhGuT
         XJYA==
X-Forwarded-Encrypted: i=1; AJvYcCXIsDxYUYCdDKXALtkCc1C6eNrndl2X+Wz5WMPdxODLTFsvoCzbrO44xcCYPwJWov/inFmy3Gjaq/GFVPrJAOdGN4cLoUzF
X-Gm-Message-State: AOJu0YxiC6uiTqHb+wpnQ97i2B17kH8pnPAUsBk8QJqlz3SdYfKUD9l8
	4UQq9rapC9eaqy/6rFp0190BmiooSRot8v6zS02jd1X802hnyoOcl0rKEno6cNQ=
X-Google-Smtp-Source: AGHT+IG5vuCEMnJybNEU3pw6Dfhrha9UVjffnJEN9pSayVDfDg6+G0gg3OeqyhGazXN+XfbDGEL4yA==
X-Received: by 2002:a17:906:5645:b0:a47:34b5:fa6e with SMTP id v5-20020a170906564500b00a4734b5fa6emr3936509ejr.2.1711543370618;
        Wed, 27 Mar 2024 05:42:50 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.206.205])
        by smtp.gmail.com with ESMTPSA id gx16-20020a170906f1d000b00a4707ec7c34sm5379175ejb.166.2024.03.27.05.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 05:42:50 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 27 Mar 2024 13:40:57 +0100
Subject: [PATCH 04/22] bluetooth: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240327-module-owner-virtio-v1-4-0feffab77d99@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=797;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=RVE008LGGmmk5WXgZGxtm6p/ays+12n/AyoNVnX9umo=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBBPdBdOoV7iseHu8Ha4ifJV+o69aPjmkC0Glb
 hZvw0OYKhSJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgQT3QAKCRDBN2bmhouD
 1wI+D/9dbQLSRFm34TU4Qv7YYw/ixrbQYbzdht3LbG49prmr+l9PRN+lDKM5C7rVEcSei80vRnM
 TiW6KxYh0V1FcMmWftM5R3iPFwUdsjSJJ8STF9/qxCFrtRu4JF2jLy20hTeoVbp18elVq5cPQX7
 x0ZT+2U/6ejc+Tj67MUtextCGgzfAnxyzk869i8eMn5+xHxfOheEJYs56sRxZveNqcH02H3SJzS
 lVHZpxQrf3FRGgcwHAPt3T3Xdw8Z16tpAtE2x8gC688DaS1Xf+F0yjXhNYUD3TZ2Nf2LOIirHft
 RqrMloYSPBljyoR9aLzb+/TS3YpVgQlAvKN5d6tmlJ0nE9har9+fKbx2BcRrLp/6GDENjqsOo/l
 8CB/SP4BTOX5vsL5yzZ+pY00Qmxt0ejqUXPkWtmcx1XbG9w2k8k24TXnlZCPdLXrLhnZ2jI9LT+
 zBfzzDbBRNwOCPfTHDN6HNuuxYCdwPAnpCXF+I0jmGk74U4igIav9OArAmrq3hKZBqbWqOZI0BN
 vbbrFOmyQQ3Nr/FfhrtNyG373ZzkyCTApUHwmnIEwpxTiKH0m+OVNyP38BY9vsn1/ZkBfOPZZyU
 LMQHmHackK+l1II6lBOJVnPTDqc4EvqiFx/LJsVwQvunku2hC9omSwT9D4Wuv363XinjYsbSqRE
 G6BGGHfVkJ9lWYw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/bluetooth/virtio_bt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index 2ac70b560c46..463b49ca2492 100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -417,7 +417,6 @@ static const unsigned int virtbt_features[] = {
 
 static struct virtio_driver virtbt_driver = {
 	.driver.name         = KBUILD_MODNAME,
-	.driver.owner        = THIS_MODULE,
 	.feature_table       = virtbt_features,
 	.feature_table_size  = ARRAY_SIZE(virtbt_features),
 	.id_table            = virtbt_table,

-- 
2.34.1

