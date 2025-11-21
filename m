Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3F333ADBC
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713096; cv=none; b=RO7GBsP4GqjgrPp34Qxbt2v7sZr5WYrn31zLX75BOUweypLgY0X83b9kA9V8+/U/lUZzUsyBVGtAjg5EcCl39wiDAHG/RGDSHJuByw7aBsG/2IZ+HdFiY0quDUGWjXG6sGBllaiJtaDSzT9bLfsbmx80zvQ5Esg2HN4tZJZ2tlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713096; c=relaxed/simple;
	bh=/P1RYgORKxwE9EU9V7IqZbnP/9QJ+9L8NguSmQu/jJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NX60KWvlUCkUB8KPNhZdOU6o3Z0aVYlRnc4vm8zSxB8CjOnuV28ckRg9CQqz+nzSrOoNFi3YkV1m7Mwc0qWnRnmg2gZo7zY9qj3AmiHHU45fRIKtHtHqPJP3eSpRzCU1/1VSfBWIEdafSUBQKLOUV3p+SG46xtIvf/2mQkJODNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ux4cdNZh; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ux4cdNZh"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so1615903b3a.3
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713092; x=1764317892; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2hQwsn6Sms438Pv0Q4ngdJSSkLE/b11prNvkoKJDYo=;
        b=Ux4cdNZhOIRxJHlRCny6td3/DzWatVslk3asCxXsD2aD6hdz59p8GjJP23zVwuMilf
         N3ga6/vIFhOb5/IW8NXv4qgP8wl694CafA+Mi4pOM6dhEp9p8SCrrukojIykaIo7ZKva
         uuFN+9KU9ithdxb7YuL1ajag6EWwRkqkexOpmridCxuP+6CIBSl7Tg6IrEkMslZj/2Hq
         19mgbnDYrCSFi3W7+U7vBkVUziM0fRiKR/TK7V2hRvOlJAZLsMIXwu8LAZThNrpawnUS
         AwR3d1PvjaTw9G6y+ljlYiv6h5BgvtRv355eaNCeL2EQSpHZMaTFKS7hNw98rfWqKVC1
         B74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713092; x=1764317892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/2hQwsn6Sms438Pv0Q4ngdJSSkLE/b11prNvkoKJDYo=;
        b=osGsxrxH094uWTimzd5xCFweb+fWabcLw3NV9kGwWDbBcX1GX1WjjI6DRor788AKGv
         jl7+aAGUPofDQYgcXyScHLG70CMgbbRZnQzj/Mch9aI2DttL893l7v2d+QX17a/grk4m
         mIE8sT2+VWTVxdhh/sLnlvHsd5dUcy6tZy/e70WMXR0x1pCd4O7ARX53C9wG9WEmiqfo
         rRR/pzvB/PVfccpHi+s76jEInY0rSFOxN6rQ5Jwy+NOwy0wPYg/zkh3eMEUiJJKCrJdY
         CxtcoulLkrABVyEn0U1kCJsXuoj8mp3GEbc5W5iXpjrfLtcDnWMcbbO3RKi3dJxcBxsh
         cQwA==
X-Forwarded-Encrypted: i=1; AJvYcCX4FD4+RnmmL2ZblLbfYYJk1ZzBWNc35goeA/Pti6NmUa3TKsALxcTRL4i9z0qXI+J4VVBiyKI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3tc+u23352bo7NzTHKppWlRo20lKs4hLaYqnTvVVzZ6eZ4Pet
	mPP613y3U3LaVZYGpyEp0xnW2jySbfiWbwoXLSfbGdZtyT9SLE1v0m+b
X-Gm-Gg: ASbGncvQfTojG1btUvDstyQYFk7VzeEGbKbY9Hgk8u9KU4+9KXsYeVbtb9QNmXPxqCL
	U2UKnl9vxdLdPwx1GnTFcDTyj2RXx5NJ9S7AOQd5eo/PVXZVSvVzDhFx9m4WmHkdsik9n6riSGb
	hYmGDRLEbGAV8/Mmz5N9ra+aHVF8tj0sccQHEC5skRSn+axN+4ClFuCxCyrcNh10pRs7LWojm2a
	kUhRku8MKHcudvjLFPru5sQd+scDTVEcHEduiHxW1lOcEahL+lbDH7KJN8N5oLvdB91Cn5TVYUB
	U5TpHYra0TBQbBI3KvHoQh4sPBBP9I4Wz/0fhi0EZ6uRCoBSxiVP7yR1rN+/i6GyBtRhQhALbqx
	e7G6IsHz/C9eOThIHaJJ47+OCAne4NgaUOv4Eg4AsnPwLFRQ9fPz9IMcSiwoKepSROcwOA6VHdF
	zFKzU7bqizNXcsAMRYPeSOoWykMQ==
X-Google-Smtp-Source: AGHT+IENbSLlagXc9NX/smNIF96UgKjh9NXUi+KBRvhy18+CUMO6BxslQvGRE/2mRUDvnGhRtmvCRg==
X-Received: by 2002:a05:7022:ba1:b0:11b:b3a1:713c with SMTP id a92af1059eb24-11c9d60d20cmr498283c88.9.1763713092239;
        Fri, 21 Nov 2025 00:18:12 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:11 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 2/9] block: export bio_chain_and_submit
Date: Fri, 21 Nov 2025 16:17:41 +0800
Message-Id: <20251121081748.1443507-3-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 55c2c1a0020..a6912aa8d69 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -363,6 +363,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 	}
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
-- 
2.34.1

