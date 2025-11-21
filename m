Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766C733B977
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713112; cv=none; b=MG0f3pnI8l40Ky9eqzuLH2CmsArUGbBxhhAn10WKbmSCl3fxPUIgCF8+2gkM7HzJ4HdXeVK6fj9by+E3EtLITA4MZHaWogT8vvskeCmiFPPATakGi+JKPFFcASRs8hkaog4jld6pT3Xy1XoR0bKdx4WYsoy1TvzgsojDQjBH72I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713112; c=relaxed/simple;
	bh=9fX1h1fO3q+pLGnSgKJ0rzYXjH5JwLqWD06FUxR/tqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IPU8T6cM9HEEyvIGDoDp46zWckx1BnHBrAwoy/fJ2sgPq6dxxcidDgqgWc+UIL0+whBFsZ2gXYXcv04P7B/dkaY8lCc4VCvbIOSRwGc4xN3sFkvvXN33+hjKZvW51uSAikSh05XCACc0fVtqv+HMTxaetAIofnEZsPdx7InAHtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMVRxlgx; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMVRxlgx"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2a45877bd5eso2695400eec.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713108; x=1764317908; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teKvOHrBXVsyNlkTSBs+xMQTFkH6mnVNybU85CGmBRM=;
        b=GMVRxlgxUKkxmXrH8OK4KajPk6P2S1PiunQl9efrhxecpOcy5ShTn4IAogq9pARwtD
         UUTWSh0q5Y3jdVSzeEdmLKGLLlW0TjpscHFS0Q1S6JTXoIr6AolNu+guQUTbw6x5WX4T
         g4xXmXk+9vjBOEU3/pyPQpzXpaeDOz+kQjSX/lMZgKfZMgbw81zlfWIXnreOAEcaLZ81
         00AalZAqjL+NRVf+gLq0CUbKhEOEjZp+I5IyyNukiR5q1pU8g44uaJR5Jhe5On1ep9/F
         7ONqGVl1p1TGkJvSxn4GJp2Hjo2RjjG+ds51tUXzIcmUHJ7sQbHTT2Sfx7fTlEl1/KLk
         hf4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713108; x=1764317908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=teKvOHrBXVsyNlkTSBs+xMQTFkH6mnVNybU85CGmBRM=;
        b=v6z7ExTWk79Qf9XpekMuOprUcrlWpQtghRvWkf0ipPApj+hRC7khKu4YcJE/xl6mew
         UBtHMLmw8E+QQqlQ6oPY63ZKHZqr/2d4AIy+JeLDRfOFqm7I5arAnmV7amqMlhYrHs5G
         4N0zsYtf96tmRDdBst8p99DK/dnYMSRLHD7kBdQ3RKVm0q+bEq9hs8sh7rw4JdEHHZAP
         LtT3KwGtiFhsD6cebflVRJQC3oK1dLYkmPnyOSDRtLSlaf3sOCdAkCClzm5j7KjHvi63
         P0GicoFIsuh/1c4lwOnnCS7cvCplyGmYIgdcN2MsXrqDdD6VPsfFqyUHVdHBU0H3pzwf
         5rew==
X-Forwarded-Encrypted: i=1; AJvYcCUIWc15aBibvacCsXFSIKclCk+1tTBxVdaohS+l/TZqiS5yR6p8kSxgx2iVFBp/55UVsMUFqxc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoYOdRS2wWQqU5LbuGi5lYs0jdMWKsNpmEMuvhgVKvC5ehjZjA
	8BgACEcm1dhWBUSH/za2b2wXBxxDhNdufUwH/goxpqRrbmZPCXBNhxW0
X-Gm-Gg: ASbGncsJi2EP6xiqR1J8Kd1BaJh23j97//vocgNR2XjiZ+X06bIkRBOVSrcZbEkQRbC
	3mAFQAdcPMXdWJhguBHGfn8wS1GbSt2YtwMymgWZo1OHbqq+2nP7SPgoMCV70rt7PBnymFpGn9k
	vA00sCxiRpFbVYUv4Ee4tBCu7TFqoINNaFDxxW+lVezKX5eL0wMY8HRI+dtbkZMZF+I1H+5mFyL
	xtnvAHam5II4MxMHttximeOUNTsBV5gZRmugqCGl/Bfus4zomPncyj1r04zGfqrr3iTf1AH+0z5
	YOgmzWFqp5WC0E8MVYhzgOe9shs0boCJva+RV8nCN3sDamsE6lhNuUCg1hyXFWw6cDrd40tGBmw
	ncjihvJmyfYK2+Dw86EAXCRCeFKXIm2I1DN1LNZxVZW/TP5AT0pTiQRQpx2FUakp3Dy69STQf0y
	2Ua0I5c52/Y0/GjmcRsUJJyPxstA==
X-Google-Smtp-Source: AGHT+IFrMbMVzab5Rj4WbT0evERr8uBJOd6ao5iaP3Dv1k5XAo7Ky5wuHi6tXAqFVzNQo5RQ6s2gYA==
X-Received: by 2002:a05:7022:fb0b:b0:119:e569:f85d with SMTP id a92af1059eb24-11c94b90cb3mr1713151c88.20.1763713107996;
        Fri, 21 Nov 2025 00:18:27 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:27 -0800 (PST)
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
Subject: [PATCH 7/9] zram: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:46 +0800
Message-Id: <20251121081748.1443507-8-zhangshida@kylinos.cn>
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
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a4307465753..084de60ebaf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -730,8 +730,7 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
-	bio_chain(bio, parent);
-	submit_bio(bio);
+	bio_chain_and_submit(bio, parent);
 }
 
 static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
-- 
2.34.1

